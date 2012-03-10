module Social
  module Config
    module Ok
      include Social::Config
      
      def config
        super['ok'][Rails.env.to_s]
      end
    end
  end
end