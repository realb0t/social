module Social
  module Network
    class Ok
      include Singleton
      include Social::Network::Base
      include Social::Config::Ok
      
      def rate
        1
      end

      def initialize(params = nil)
        
        require File.join(Rails.root, 'lib/social/network/graph/ok/user')
        require File.join(Rails.root, 'lib/social/network/graph/ok/notification')
        
        super('ok', [ :user, :notification ], params)
      end
    end
  end
end
