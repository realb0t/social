Social
====================

Библиотека для обращения к API социальных сетей со стороны сервера. Содержит методы API и средства определения текущей социальной сети. 

Данная библиотека была создана в рамках проекта SocialFrame - Шаблон для IFrame приложений на базе Sinatra (Padrino). Но библиотеку можно также использовать и для Rails-приложений и других. 

Библиотека решает следующие задачи:
* Определение типа соцсети до создания сессии и авторизации по средствам Rack::Builder
* Осуществление общих запросов к API соцсети
* Генерирует уникальный пользовательский UID и уникальный SESSION_ID для сессии на основе SID соцсети

Поддержка социальных сетей:
* vk.com
* odnoklassniki.ru

Поддерживаемые методы API:
* Получает профиль пользователя
* Получить список друзей для пользователя
* Получить профили друзей
* Работа с балансом пользователя (только для vk.com)

Установка
---------------------

    gem install social

Для Gemfile

    gem 'social'

Использование
---------------------

Получение профиля пользователя (get user profile)

    Social::Network(:ok).user.get_info(uid)

или

    Social::Network::Vk.user.get_info(uid)

или отправка нотификации

    Social::Network(social_type).notification.send(:message => msg, :uids => [ ... ])

Обращение к текущей социальной сети осуществляется после Глобального определения этого типа (см. ниже). При этом возможны следующие вызовы.

    Social::Network.current.user.get_info(uid)


Глобальное определение типа социальной сети
---------------------

    Social::Env.init(params[:social_types])

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

Для SinglePage приложения:
Предпологается, что первый GET запрос приходит на URL из SocialPrefix,
а последующие запросы идут уже без без SocialPrefix и тип соцсети
берется из сессии и передается в метод Social::Env.init(<SOCIAL_TYPE>).

Для "Многостраничного" приложения:
Предпологается, что все запросы все запросы осуществляются с помощью
SocialPrefix

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

