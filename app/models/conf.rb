class Conf
  include ::Squire::Base

  def self.config_file
    File.join(Rails.root, 'config', 'webschleuder.yml')
  end

  def self.api_uri
    "#{api_protocol}://#{api.host}:#{api.port}/"
  end

  def self.api_protocol
    # Cast to String to catch the case when users write "true" into the config file.
    if api.use_tls.to_s == "true"
      'https'
    else
      'http'
    end
  end

  # Disabled for now. Maybe we'll use this code some day, if we decide in favor of file-based verification.
  #def self.api_cert_file
  #  File.expand_path(api.remote_cert_file)
  #end

  def self.api_use_tls?
    api.use_tls.to_s == "true"
  end

  squire.source self.config_file
  squire.namespace Rails.env, base: :defaults
end
