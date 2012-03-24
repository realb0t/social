module Social
  class Config
    module Ok
      def config
        unless @config
          @env = ENV['APP_ENV'] || ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
          @config_ins = Social::Config.new('ok')
          @config = @config_ins.config['ok'][@env]
        end

        @config
      end
    end
  end
end