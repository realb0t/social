module Social
  class Config
    module Vk
      
      def config
        
        unless @config
          @env = ENV['APP_ENV'] || ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
          @config_ins = Social::Config.new(:vk)
          @config = @config_ins.config[@env]
        end

        @config
      end

      def safe_config(auth_params = {})
        auth_params.merge \
          :app_id         => Social::Network(:vk).config['app_id'],
          :logged_user_id => auth_params['uid']
      end

    end
  end
end