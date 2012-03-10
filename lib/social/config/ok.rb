module Social
  module Config
    module Ok
      include Social::Config
      
      def config
        env = ENV['APP_ENV'] || ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
        super['ok'][]
      end
    end
  end
end