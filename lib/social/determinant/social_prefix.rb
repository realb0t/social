class Social::Determinant

  # Класс Rack::Builder'a обеспечивающий
  # работу подхода social-prefix
  #
  # Этот подход заключается в том, что если на сервер
  # приходит запрос вида /<SOCIAL_PREFIX>/*, где 
  # SOCIAL_PREFIX может принимать значения типа vk, odkl
  # и п.р.
  #
  # Этот подход выполняет 2 задачи
  #
  # 1) Обеспечивает содержание в URL для Одноклассников слова odkl
  # для показа аватаров пользователей, без добавления лишних роутов
  # в приложение.
  # 2) Обеспечивает выбор и определение используемой социальной сети
  # без добавления этой логики в приложение
  class SocialPrefix < self

    # Класс провайдерa для обеспечения
    # social-prefix, принимает 
    # prefix от builder'a и подмешивает
    # social_env в параметры запроса
    class Provider

      # @param [String]
      # @return [Class]
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
            prefix  = self.class.prefix
            type    = Social.type_by_prefix(prefix)
            id      = Social.id_by_type(type)

            request.GET['social_env'] = {
              'prefix' => prefix, 'type' => type, 'id' => id
            }

            @app.call(request.env)
          end

        end

        klass.prefix = prefix
        klass
      end

    end

    def self.produce(app)
      new do

        map '/' do
          run app
        end

        Social.type_prefixes.each_with_index do |prefix, index|

          map '/' + prefix do
            use Provider.build(prefix)
            run app
          end

        end

      end
    end

  end
end