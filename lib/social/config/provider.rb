class Social::Config::Provider

  class << self

    def factory_data(social_type, type = :file)
      factory_driver(social_type, type).config_data[env]
    end

    def env
      @env ||= ENV['APP_ENV'] || ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
    end

    def factory_driver(social_type, type)
      case type
      when :file
        Social::Config::Driver::File.new(social_type)
      end
    end

  end

end