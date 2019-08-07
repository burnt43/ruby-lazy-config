require 'pathname'
require 'yaml'
require 'active_support'

module LazyConfig
  class Config
    class << self
      attr_accessor :environment
      attr_accessor :base_dir

      def environment
        @environment || 'development'
      end
    end
  end

  module Loader
    extend ActiveSupport::Concern

    class_methods do
      def environment_aware?
        self.environment_aware.nil? ? true : self.environment_aware
      end

      def config_filename
        "#{ActiveSupport::Inflector.underscore(name)}.yaml"
      end

      def config_pathname
        @pathname ||= (
          base_pathname = Pathname.new(LazyConfig::Config.base_dir)

          complete_dir_pathname = 
            if environment_aware?
              base_pathname.join(LazyConfig::Config.environment)
            else
              base_pathname 
            end

          complete_dir_pathname.join(config_filename)
        )
      end

      def config
        @config ||= YAML.load(IO.read(config_pathname))
      end
    end

    included do
      class << self
        attr_accessor :environment_aware
      end
    end
  end
end