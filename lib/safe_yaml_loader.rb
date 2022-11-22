class SafeYamlLoader
  class << self
    def load_file(filepath)
      load(File.read(filepath))
    end

    # Load YAML in the stricter "safe" mode (which disallows e.g. custom
    # classes) but allow aliases.
    def load(input)
      # This works in all ruby versions from 2.6 to and including 3.1.
      YAML.safe_load(input, aliases: true)
    end
  end
end
