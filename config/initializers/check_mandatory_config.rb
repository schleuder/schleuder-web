if API_REQUIRED

  def fatal(msg)
    $stderr.puts "Error: #{msg}"
    exit 1
  end

  # Disabled for now. Maybe we'll use this code some day, if we decide in favor of file-based verification.
  #
  #if Conf.api.remote_cert_file.blank?
  #  fatal "Can't verify connection to API without remote_cert_file! Set it in config/schleuder-web.yml"
  #end
  #
  #file = Pathname.new(Conf.api.remote_cert_file).expand_path
  #if ! file.readable?
  #  fatal "remote_cert_file is set to a not readable file (in config/schleuder-web.yml)"
  #end

  if Conf.api.tls_fingerprint.blank?
    fatal "Error: 'tls_fingerprint' is empty but required (in config/schleuder-web.yml)."
  end

  if Conf.api_key.blank?
    fatal "Error: 'api_key' is empty but required (in config/schleuder-web.yml)."
  end

  if Conf.api.host.blank?
    fatal "Error: 'host' is empty, can't connect (in #{ENV['SCHLEUDER_CONF_CONFIG']})."
  end

  if Conf.api.port.blank?
    fatal "Error: 'port' is empty, can't connect (in #{ENV['SCHLEUDER_CONF_CONFIG']})."
  end

end
