class Social::Network
  class Vk < Base

    def social_type
      :vk
    end

    def safe_config(auth_params = {})
      auth_params.merge \
        :app_id         => Social::Network(:vk).config['app_id'],
        :logged_user_id => auth_params['uid']
    end
    
    def rate
      6
    end

    def initialize(params = nil)
      super('vk', [ :user, :notification ], params)
    end
  end
end
