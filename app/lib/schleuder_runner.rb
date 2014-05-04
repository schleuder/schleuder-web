class SchleuderRunner
  def initialize(msg, recipient)
    # TODO: catch GPGME::Error::DecryptFailed
    # TODO: write msg to file until runner ends in order to never loose a message?
    @mail = Mail.new(msg)
    # TODO: Fix strange errors about wrong number of arguments when overriding Message#initialize
    @mail.setup recipient

    # TODO: use custom logger
    # TODO: implement forwarding messages to listname-owner@

    setup_list

    if @mail.sendkey_request?
      send_key
    end


    # TODO: implement receive_*
    if @mail.validly_signed?
      output = run_plugins

      if @mail.request?
        reply_to_sender(output)
      else
        send_to_subscriptions
      end
    else 
      if ! @list.receive_signed_only?
        send_to_subscriptions
      else
        return error(:msg_must_be_signed)
      end
    end
  end

  def send_key
    # TODO: move this into Mail::Message, without breaking their supermetaleetprogramming...
    @mail.reply_sendkey(@list).deliver
    exit
  end

  def error(msg)
    if msg.is_a?(Symbol)
      msg = t(msg)
    end
    # TODO: logging
    $stderr.puts msg
    exit 1
  end

  def reply_to_sender(output)
    @mail.reply_to_sender(output).deliver
  end
  
  def send_to_subscriptions
    new = @mail.clean_copy(@list)
    @list.subscriptions.each do |subscription|
      out = subscription.send_mail(new)
    end
  end

  def setup_list
    if ! @list = List.by_recipient(@mail.recipient)
      error('No such list.')
    end
    # This cannot be put in List, as Mail wouldn't know it then.
    ENV['GNUPGHOME'] = @list.listdir
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
