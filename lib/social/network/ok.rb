class Social::Network
  class Ok < Base

    def social_type
      :ok
    end

    def safe_config(auth_params = {})
      auth_params.merge \
        :api_server       => Social::Network(:ok).config[:api_server],
        :application_key  => Social::Network(:ok).config[:application_key],
        :logged_user_id   => auth_params['uid']
    end
    
    def rate
      1
    end

    def initialize(params = nil)
      super('ok', [ :user, :notification ], params)
    end
  end
end
