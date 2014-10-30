require 'active_support/hash_with_indifferent_access'

class Social::Determinant
  class RequestParam < self

    class Provider

      def self.build(social_type)
        klass = Class.new do

          class << self
            attr_accessor :social_type
          end

          def initialize(app)
            @app = app
          end

          def call(env)
            request      = Rack::Request.new(env)
            social_type  = self.class.social_type
            prefix       = Social.prefix_by_type(social_type)
            id           = Social.id_by_type(social_type)
            
            request.GET['social_env'] = {
              'prefix' => prefix, 'type' => social_type, 'id' => id
            }

            @app.call(request.env)
          end

        end

        klass.social_type = social_type
        klass
      end

    end

    def self.produce(app)
      new do

        map '/' do
          params = HashWithIndifferentAccess.new(Social.social_params(request.GET))
          if params.present? && type = Social.params_social_type(params)
            use Provider.build(type)
            run app
          else
            run app
          end
        end

      end
    end
  end
end