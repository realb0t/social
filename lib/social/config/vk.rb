module Social
  module Config
    module Vk
      include Social::Config
      
      def config
        env = ENV['APP_ENV'] || ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
        super['vk'][env.to_s]

      end
    end
  end
end