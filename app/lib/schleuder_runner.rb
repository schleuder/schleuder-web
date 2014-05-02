class SchleuderRunner
  def initialize(msg, recipient)
    # TODO: use custom logger
    @list = List.where(email: recipient).first
    if ! @list
      return error('No such list.')
    end
    ENV['GNUPGHOME'] = @list.listdir

    # TODO: decrypt+verify
    # TODO: detect request- or list-message

    @mail = Mail.new(msg)
    if @mail.encrypted?
      begin
        @mail = @mail.decrypt(verify: true)
      rescue GPGME::Error::DecryptFailed
        return error("Decrypting failed")
      end
    elsif @mail.signed?
      # TODO: test/fix
      @mail = @mail.verify?
    end

    run_plugins

    new = @mail.clean_copy(@list)
    @list.subscriptions.each do |subscription|
      out = subscription.send_mail(new)
    end
  end

  def run_plugins
    setup_plugins
    # TODO: handle responses if request-mail
    # TODO: handle errors for request- (reply) and list-mails (reply or metadata[:error])
    output = []
    @mail.keywords.each do |keyword|
      if keyword_admin_only?(keyword) && ! mail_from_admin?
        # TODO: write error to metadata[:errors]?
        output << "Error: Use of '#{keyword}' is restricted to list-admins only."
        next
      end
      command = keyword.gsub('-', '_')
      if Plugin.respond_to?(command)
        output << Plugin.send(command, @mail)
      end
    end
    if @mail.request?
      sub = Subscription.find_by(fingerprint: @mail.signature.fingerprint)
      if ! sub
        raise "Invalid signer"
      end

      msg = ["Result of your commands:"]
      if output.empty?
        msg << "There was no output."
      else 
        msg += output
      end

      @mail.reply do
        from @list.email
        to   sub.email
        body msg.join("\n\n")
      end.deliver

      exit
    end
  rescue
    # TODO: notify admin
  end

  def keyword_admin_only?(keyword)
    @list.keywords_admin_only.include?(keyword)
  end

  def mail_from_admin?
    @list.admins.find do |admin|
      admin.fingerprint == @mail.signature.fingerprint
    end
  end

  private

  def setup_plugins
    Dir["#{SchleuderConfig.plugins_dir}/*.rb"].each do |file|
      require file
    end
  end

end
