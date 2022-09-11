module Squire
  module Parser
    module YAML
      def self.parse(path)
        rendered_yaml = ERB.new(File.read(path)).result
        if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.1.0')
          ::YAML::load(rendered_yaml, aliases: true)
        else
          ::YAML::load(rendered_yaml)
        end
      end
    end
  end
end
