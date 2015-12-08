class Conf
  include ::Squire::Base

  def self.config_file
    file_name = 'webschleuder.yml'
    global_config = File.join(base_dir, file_name)
    if File.readable?(global_config)
      global_config
    else
      File.join(Rails.root, 'config', file_name)
    end
  end

  def self.base_dir
    ENV['SCHLEUDER_BASE_DIR'].try(:chomp, '/') || '/etc/schleuder'
  end

  squire.source self.config_file
  squire.namespace Rails.env, base: :defaults
end
