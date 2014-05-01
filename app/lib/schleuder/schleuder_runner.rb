class SchleuderRunner
  def initialize(msg, recipient)
    @list = List.where(email: recipient).first
    if ! @list
      return error('No such list.')
    end

    setup_gnupg
    setup_smtp

    # TODO: decrypt+verify
    # TODO: detect request- or list-message

    @mail = Mail.new(msg)
    if @mail.encrypted?
      @mail = @mail.decrypt(verify: true)
    elsif @mail.signed?
      # TODO: test/fix
      @mail = @mail.verify?
    end

    run_plugins
    send_to_subscribers
  end


  def send_to_subscribers
    new = @mail.dup #.clean_copy
    @list.subscribers.each do |subscriber|
      #out = subscriber.send(new, list)
      new.to = subscriber.email
      new.deliver
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
    if ! output.compact!.empty?
      # TODO: reply output to sender
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

  def config
    @config ||= SchleuderConfig.new
  end
  
  def listdir
    @listdir ||= File.join(
        config.lists_dir,
        @list.email.split('@').reverse
      )
  end

  def setup_smtp
    Mail.defaults do
      delivery_method :sendmail
    end
  end

  def setup_gnupg
    ENV['GNUPGHOME'] = listdir

    if @list.gpg_passphrase.present?
      # TODO: move this to gpgme/mail-gpg
      require 'open3'
      ENV['GPG_AGENT_INFO'] = `eval $(gpg-agent --allow-preset-passphrase --daemon) && echo $GPG_AGENT_INFO`
      `gpgconf --list-dir`.match(/libexecdir:(.*)/)
      gppbin = File.join($1, 'gpg-preset-passphrase')
      Open3.popen3(gppbin, '--preset', @list.fingerprint) do |stdin, stdout, stderr|
        stdin.puts @list.gpg_passphrase
      end

      # Call cleanup when script finishes.
      Signal.trap(0, proc { cleanup })
    end
  end

  def cleanup
    puts "cleanup called"
    pid = ENV['GPG_AGENT_INFO'].split(':')[1]
    if pid
      Process.kill('TERM', pid.to_i)
    end
  rescue => e
    $stderr.puts "Failed to kill gpg-agent: #{e}"
  end

  def setup_plugins
    config.plugins_dirs.each do |dir|
      Dir["#{dir}/*.rb"].each do |file|
        require file
      end
    end
  end

end
