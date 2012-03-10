Social API wrapper and Tools
====================

This is social networks api wrapper and authorization tools for social applications.

Now it is a compilation of code from various projects in production. Without tests. =(
NOT RECOMMENDED USE IN PRODUCTION.

Now supported networks:

* vk.com 
* odnoklassniki.ru

Now supported features:

* Get user profile
* Get user friend profiles
* Get user balance and charge off (only vk.com)
* Initialize environment by request (example /odkl/* and /vk/*)
* Authorization user for Rails application (support transition between pages)

Install

    gem install social


Use wrapper
---------------------

    Social::Network(:ok).user.get_info(uid)
or
    Social::Network::Vk.user.get_info(uid)
or
    Social::Network(socio_type).notification.send(:message => msg, :uids => [ ... ])

Use Tools
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

For Example:

on request /odkl/*

    params[:social_env][:id] # => 1

and after include Social::Helper::Controller in your Rails application controller

    Social::Env.id # => 1
    Social::Env.type # => :ok
    Social::Env.prefix # => :odkl

TODO
---------------------

* Tests, tests, tests ...
* More network
* More and beautiful API for Rails, Sinatra and Rack applications
* More supported features

Welcome to contributing.
