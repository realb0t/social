# Add helper methods for Social in base controller class
module Social
  module Helper
    module Controller
  
      def self.included(base)
        base.instance_eval do
          helper_method :current_social_type, :current_social_type_id, :current_social_prefix
          before_filter :init_social_env
        end
      end

      # Helper, returned social type id from request
      # (controller, view).current_social_type_id
      def current_social_type_id
        @current_social_type_id ||= params[:soc_id]
      end

      # Helper, returned social type from request
      # (controller, view).current_social_type
      def current_social_type
        @current_social_type ||= params[:soc_type]
      end

      # Helper, returned social type prefix from request
      # (controller, view).current_social_type_prefix
      def current_social_prefix
        @current_social_prefix ||= params[:soc_prefix]
      end

      protected

        def init_social_env
          #Social.current_id = params[:soc_id]
          #Social.current_type = params[:soc_type]
          #Social.current_prefix = params[:soc_prefix]
          
          Social::Env.init(params)
        end
        
    end
  end
end