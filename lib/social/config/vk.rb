module Social
  class Config
    module Vk
      
      def config
        
        unless @config
          @env = ENV['APP_ENV'] || ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
          @config_ins = Social::Config.new('vk')
          @config = @config_ins.config['vk'][@env]
        end

        @config
      end

    end
  end
end