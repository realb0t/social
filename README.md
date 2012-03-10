Social API wrapper and Tools
====================

This is social networks api wrapper and authorization tools for social applications.

Now it is a compilation of terrible code from various projects. Without tests and benchmark. =(

## NOT RECOMMENDED USE IN PRODUCTION

Now supported networks:

* vk.com 
* odnoklassniki.ru
* mail.ru (plans to support)
* facebook.com (plans to support)

Now supported features:

* Get user profile
* Get user friend profiles
* Get user balance and charge off (only vk.com)
* Initialize environment by request (example /odkl/*, /vk/* and other) - Rack Middleware
* Authorization user for Rails application (support transition between pages)
* Parameterized wrapper to call the API methods

Install

    gem install social


Use wrapper
---------------------

    Social::Network(:ok).user.get_info(uid)

or

    Social::Network::Vk.user.get_info(uid)

or

    Social::Network(socio_type).notification.send(:message => msg, :uids => [ ... ])

Use environment tools
---------------------

In config.ru

    builder = Social::Builder::produce(App::Application)
    run builder

Adds an initializing environment.

    request['social_env'] = {
      'prefix' => <SOCIAL_PREFIX>, 
      'type'   => <SOCIAL_TYPE_NAME>,
      'id'     => <SOCIAL_TYPE_ID>
    }

For example, on request /odkl/*

    params[:social_env][:id] # => 1

and after 
    
    include Social::Helper::Controller 

in your Rails application controller

    Social::Env.id # => 1
    Social::Env.type # => :ok
    Social::Env.prefix # => :odkl

TODO
---------------------

* Tests, tests, tests ...
* More network
* More and beautiful API for Rails, Sinatra and Rack applications
* More supported features

### Welcome to contributing!
