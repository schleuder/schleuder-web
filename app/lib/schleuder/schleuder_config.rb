class SchleuderConfig
  def initalize
    @config = YAML.load(File.read("#{base_dir}/schleuder.conf"))
    
    # Define getter-methods for each config-value.
    @config.keys.each do |key|
      self.class.send(:define_method, key) do
        @config[key]
      end
    end
  end


  def plugins_dirs
    @plugins_dirs ||= [
        "#{base_dir}/plugins/",
        self.plugins_dir
      ]
  end

  def lists_dir
    '/etc/schleuder/lists/'
  end

  private

  def base_dir
    ENV['SCHLEUDER_BASE_DIR'] || '/etc/schleuder/'
  end
end
