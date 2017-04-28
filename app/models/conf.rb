class Conf
  include ::Squire::Base

  def self.config_file
    File.join(Rails.root, 'config', 'schleuder-web.yml')
  end

  def self.api_uri
    "https://#{api.host}:#{api.port}/"
  end

  # Disabled for now. Maybe we'll use this code some day, if we decide in favor of file-based verification.
  #def self.api_cert_file
  #  File.expand_path(api.remote_cert_file)
  #end

  squire.source self.config_file
  squire.namespace Rails.env, base: :defaults
end
