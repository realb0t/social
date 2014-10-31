class Social::Network
  class Vk < Base
    include Social::Config::Vk
    
    def rate
      6
    end

    def initialize(params = nil)
      super('vk', [ :user, :notification ], params)
    end
  end
end
