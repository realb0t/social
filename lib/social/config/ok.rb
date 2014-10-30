class Social::Config
  module Ok

    def config
      
      unless @config
        @env = ENV['APP_ENV'] || ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
        @config_ins = Social::Config.new(:ok)
        @config = @config_ins.config[@env]
      end

      @config
    end

    def safe_config(auth_params = {})
      auth_params.merge \
        :api_server       => Social::Network(:ok).config[:api_server],
        :application_key  => Social::Network(:ok).config[:application_key],
        :logged_user_id   => auth_params['uid']
    end
  end
end