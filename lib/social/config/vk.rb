module Social
  module Config
    module Vk
      include Social::Config
      
      def config
        super['vk'][Rails.env.to_s]
      end
    end
  end
end