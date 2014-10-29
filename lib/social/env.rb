module Social
  class Env

    include Singleton
    attr_accessor :id, :type, :prefix

    # Класс объекта определяющего соц.окружения по 
    # параметрам запроса
    class << self

      def init(params)

        if params[:social_env].present?
          # @deprecated
          #
          # Если параметр задается с помощью RackBuilder
          # через SocialPrefix и передается как social_env
          # через параметры приложения
          env             = params[:social_env]
          instance.id     = env[:id] 
          instance.type   = env[:type] 
          instance.prefix = env[:prefix]

        elsif Social.social_request?(params)
          #
          # Определяем тип социальной сети по параметрам
          # первоначального запроса. Например если передан параметр
          # viewer_id и sid, то это Вконтакте

          social_type = Social.request_social_type(params)
          instance.type = social_type
          instance.prefix = Social.prefix_by_type(social_type)
          instance.id = Social.id_by_type(social_type)
        else
          raise "Can't find social env in params #{params.inspect}"
        end

        instance.instance_variable_set(@inited, true)
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