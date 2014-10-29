Social
====================

Библиотека для обращения к API социальных сетей со стороны сервера. Содержит методы API и средства определения текущей социальной сети. 

Предпологается использование в IFrame приложениях, на базе RoR или Sinatra. 
(only IFrame applications).

Поддержка социальных сетей

* vk.com
* odnoklassniki.ru
* mail.ru (в планах)
* facebook.com (в планах)

Подерживаемые методы:

* Получает профиль пользователя
* Получить список друзей для пользователя
* Получить профили друзей
* Работа с балансом пользователя (только для vk.com)
* Инициализация социальной сети с помощью SocialPrefix (например для запросов /odkl/*, /vk/*) с помощью Rack Middleware
* 
* Parameterized wrapper to call the API methods

Установка (Install)

    gem install social

Для Gemfile

    gem 'social'


Использование (Usage)
---------------------

Получение профиля пользователя (get user profile)

    Social::Network(:ok).user.get_info(uid)

или

    Social::Network::Vk.user.get_info(uid)

или отправка нотификации

    Social::Network(social_type).notification.send(:message => msg, :uids => [ ... ])


Определение соцсети с помощью SocialPrefix
---------------------

SocialPrefix позволяет определять социальную сеть по строке запроса т.е.

- без использования субдоменов
- без определения соц.сети по параметрам запроса (что также поддерживается)
- без добавления доп.роутов в приложение

Также пользоволяет решить проблему с показам аватаров пользователей в Одноклассниках, для которых в REFERRAL должно быть слово "odnoklassniki" или "odkl".

config.ru

    builder = Social::Builder::produce(Example::Application)
    run builder

При этом в параметры запроса добавляется ключ social_env
со следующим содержанием

    request.params['social_env'] = {
      'prefix' => <SOCIAL_PREFIX>, 
      'type'   => <SOCIAL_TYPE_NAME>,
      'id'     => <SOCIAL_TYPE_ID>
    }

Например, при запросе /odkl/*

    params[:social_env][:id] # => 1
    params[:social_env][:prefix] # => 'odkl'
    params[:social_env][:type] # => :ok

Определение соцсети с помощью
---------------------

Помимо SocialPrefix определение соцсети можно осуществлять
с помощью параметров запроса. Например если запрос содержит
параметры viewer_id и sid, то можно сказать что это 
соцсеть ВКонтакт.

Этот способ также предпологает использование Rack::Builder.

TODO
---------------------

* Тесты с использованием VCR
* Поддержка Mail.ru
* Поддержка Facebook
* Больше поддерживаемых "общих" методов API

