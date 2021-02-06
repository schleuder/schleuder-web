class Conf
  include ::Squire::Base
  EXT_CONF = ENV['SCHLEUDERWEB_CONFIG_FILE']

  def self.config_file
    if EXT_CONF.present? && File.readable?(EXT_CONF)
      EXT_CONF
    else
      File.join(Rails.root, 'config', 'schleuder-web.yml')
    end
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
