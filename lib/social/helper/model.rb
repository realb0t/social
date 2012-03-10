# Add helper methods for Social in user model class (Active record)
module Social
  module Helper
    module Model

      def self.included(base)
        base.instance_eval do
          attr_accessor :auth_params 
        end
      end

      # Alias for model.current_social_type
      # model.current_provider String
      # @params social_type_id = nil
      def current_provider(social_type_id = nil)
        current_social_type(social_type_id)
      end

      # Return current social type or social type by social_type_id
      # model.current_social_type String
      # @params social_type_id = nil
      def current_social_type(social_type_id = nil)
        if social_type_id
          @current_provider = Social.type_by_id(social_type_id)
        elsif auth_params && auth_params[:social_type]
          @current_provider = auth_params[:social_type]
        else
          @current_provider = Social::Env.type
        end

        @current_provider
      end

      # Return current social type id
      # model.current_social_type String
      def current_social_type_id()
        unless @current_social_type_id
          @current_social_type_id = Social::Env.id
        end

        @current_social_type_id
      end

      # Make standart hash (for js) from model data
      # model.to_hash hash
      # @params params = {}
      def to_hash(params = {})
        {
          :id         => id,
          :first_name => first_name,
          :last_name  => last_name,
          :uid        => social_references.last.uid,
          :name       => "#{first_name} #{last_name}",
          :gender     => (male? ? 'male' : 'female'),
          :birthday   => birthdate
        }
      end

    end
  end
end