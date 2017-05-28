module Squire
  module Parser
    module YAML
      def self.parse(path)
        ::YAML::load(ERB.new(File.read(path)).result)
      end
    end
  end
end
