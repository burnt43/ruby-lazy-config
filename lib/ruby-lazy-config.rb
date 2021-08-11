require 'pathname'
require 'yaml'
require 'active_support/concern'
require 'active_support/inflector'
require 'active_support/core_ext/hash/indifferent_access'

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
        "#{ActiveSupport::Inflector.underscore(ActiveSupport::Inflector.demodulize(name))}.yaml"
      end

      def config_pathname
        @pathname ||= (
          base_pathname = Pathname.new(LazyConfig::Config.base_dir)

          complete_dir_pathname = 
            if environment_aware?
              base_pathname.join(LazyConfig::Config.environment.to_s)
            else
              base_pathname 
            end

          complete_dir_pathname.join(config_filename)
        )
      end

      def config
        @config ||= YAML.load(IO.read(config_pathname)).with_indifferent_access
      end

      def with_config(&block)
        # Yield the config hash to the block. You can then modify the config
        # hash however you like. After the block executes, we'll set the
        # config hash to nil, so the subsequent call to the config() method
        # will load the config back from the yaml file.
        result = block.call(@config)
        @config = nil
        result
      end
    end

    included do
      class << self
        attr_accessor :environment_aware
      end
    end
  end
end
