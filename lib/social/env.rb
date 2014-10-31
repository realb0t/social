module Social
  class Env

    include Singleton
    attr_accessor :id, :type, :prefix

    # Класс объекта определяющего соц.окружения по 
    # параметрам запроса
    class << self

      def init(social_type)
        instance.type   = social_type
        instance.id     = Social.id_by_type(social_type)
        instance.prefix = Social.prefix_by_type(social_type)
        instance.instance_variable_set(:"@inited", true)
      end

      def init_by_params(params)
        unless social_type = Social.request_social_type(params)
          raise "Can't find social env in params #{params.inspect}"
        else
          init(social_type)
        end
      end

      delegate :id, :type, :prefix, :inited?, to: :instance

    end

    def initialize
      @inited = false
    end

    def inited?
      @inited
    end

  end

end