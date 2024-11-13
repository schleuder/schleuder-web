require 'safe_yaml_loader'

module Squire
  module Parser
    module YAML
      def self.parse(path)
        SafeYamlLoader.load(ERB.new(File.read(path)).result)
      end
    end
  end
end
