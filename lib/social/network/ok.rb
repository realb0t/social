class Social::Network
  class Ok < Base
    include Social::Config::Ok
    
    def rate
      1
    end

    def initialize(params = nil)
      super('ok', [ :user, :notification ], params)
    end
  end
end
