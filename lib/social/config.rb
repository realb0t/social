module Social
  class Config

    def initialize(network_name)
      @network_name = network_name
      @config_file_data = {}
    end

    def network_name
      @network_name
    end
    
    def config
      @config_data ||= load_config_file[@network_name]
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
      @config_root ||= ENV['SOCIAL_CONFIG_ROOT']
      @config_root ||= File.join('.', 'config')
    end

    def config_file_path
      @config_file_path ||= ENV['SOCIAL_CONFIG_PATH']
      @config_file_path ||= File.join(self.config_root, 'social.yml')
    end

    def load_config_file
      @config_file_data[config_file_path] ||= YAML.load_file(config_file_path).with_indifferent_access
    end


  end
end
