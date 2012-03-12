module Social
  class Provider
    def self.build(prefix)

      klass = Class.new do

        class << self
          attr_accessor :prefix
        end

        def initialize(app)
          @app = app
        end

        def call(env)
          request = Rack::Request.new(env)

          prefix = self.class.prefix
          type   = Social.type_by_prefix(prefix)
          id     = Social.id_by_type(type)

          request.GET['social_env'] = {
            'prefix' => prefix, 
            'type'   => type,
            'id'     => id
          }

          # Old
          request.GET['soc_prefix'] = prefix
          request.GET['soc_type']   = type
          request.GET['soc_id']     = id

          @app.call(request.env)
        end

      end

      klass.prefix = prefix
      klass
    end
  end
end