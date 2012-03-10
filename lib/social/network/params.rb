module Social
  module Network
    module Params

      def params()
        @params
      end

      def params!(params)
        @params = params
        self
      end

      def param(key)
        @params[key]
      end

      def param!(key, value)
        @params[key] = value
        self
      end

      protected

        def init_params(params)
          @params = params.is_a?(Hash) ? params : {}
        end

    end
  end
end
