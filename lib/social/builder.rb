module Social

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
  class Builder < Rack::Builder
    def self.produce(app)
      new do

        map '/' do
          run app
        end

        Social.type_prefixes.each_with_index do |prefix, index|

          map '/' + prefix do
            use Social::Provider.build(prefix)
            run app
          end

        end

      end
    end
  end
end