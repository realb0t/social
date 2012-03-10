module Social
  class Env

    include Singleton
    attr_accessor :id, :type, :prefix

    class << self

      def init(params)
        raise "Cant find social env in params #{params.inspect}" unless params[:social_env]

        env             = params[:social_env]
        instance.id     = env[:id] 
        instance.type   = env[:type] 
        instance.prefix = env[:prefix] 
      end

      def id
        instance.id
      end

      def type
        instance.type
      end

      def prefix
        instance.prefix
      end

    end

  end

end