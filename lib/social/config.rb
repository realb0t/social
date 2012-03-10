module Social
  module Config

    @@network_name = nil

    def self.included(network)
      network.send(:include, InstanceMethods)
      @@network_name = network.name.split('::').last.downcase 
    end

    module InstanceMethods

      def network_name
        @@network_name
      end

      def network
        @network
      end
      
      def config
        @config_data ||= load_config_file
      end

      def config_file_path=(new_path)
        @config_file_path = new_path
        @config           = load_config_file if @config_data
      end

      def config_root=(new_root)
        @config_root = new_root
      end

      def config_root
        @config_root ||= File.join(Rails.root, 'config') if defined?(Rails)
        @config_root ||= File.join('.', 'config')
      end

      def config_file_path
        @config_file_path ||= File.joint(self.config_root, 'social.yml')
      end

      def load_config_file
        YAML.load_file(config_file_path).with_indifferent_access
      end

    end

  end
end
