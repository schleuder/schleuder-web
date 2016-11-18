class Conf
  include ::Squire::Base

  def self.config_file
    File.join(Rails.root, 'config', 'webschleuder.yml')
  end

  squire.source self.config_file
  squire.namespace Rails.env, base: :defaults
end
