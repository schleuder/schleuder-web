class Conf
  include ::Squire::Base

  def self.config_file
    File.join(Rails.root, 'config', 'webschleuder.yml')
  end

  def self.schleuderd_uri
    "#{schleuderd_protocol}://#{schleuderd.host}:#{schleuderd.port}/"
  end

  def self.schleuderd_protocol
    # Cast to String to catch the case when users write "true" into the config file.
    if schleuderd.use_tls.to_s == "true"
      'https'
    else
      'http'
    end
  end

  # Disabled for now. Maybe we'll use this code some day, if we decide in favor of file-based verification.
  #def self.schleuderd_cert_file
  #  File.expand_path(schleuderd.remote_cert_file)
  #end

  def self.schleuderd_use_tls?
    schleuderd.use_tls.to_s == "true"
  end

  squire.source self.config_file
  squire.namespace Rails.env, base: :defaults
end
