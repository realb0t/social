module Social
  module Network
    class Vk
      include Singleton
      include Social::Network::Base
      include Social::Config::Vk
      
      def rate
        6
      end

      def initialize(params = nil)
        
        require File.join(Rails.root, 'lib/social/network/graph/vk/user')
        require File.join(Rails.root, 'lib/social/network/graph/vk/notification')
        
        super('vk', [ :user, :notification ], params)
      end
    end
  end
end
