require 'singleton'
require 'active_support/all'
require 'rack'
require 'social/version'
require 'social/determinant'
require 'social/determinant/social_prefix'
require 'social/determinant/request_param'
require 'social/config'
require 'social/config/vk'
require 'social/config/ok'
require 'social/env'
require 'social/network'
require 'social/network/graph'
require 'social/network/base'
require 'social/network/ok'
require 'social/network/vk'
require 'social/network/graph/tail'
require 'social/network/graph/ok'
require 'social/network/graph/ok/base'
require 'social/network/graph/ok/notification'
require 'social/network/graph/ok/user'
require 'social/network/graph/vk'
require 'social/network/graph/vk/base'
require 'social/network/graph/vk/notification'
require 'social/network/graph/vk/user'
require 'social/network/stub'
require 'social/network'
require 'social/networks'

module Social

  SOCIAL_TYPES = {
    1 => :ok,
    2 => :vk,
    3 => :fb
  }

  SOCIAL_PREFIX = {
    :ok => 'odkl',
    :vk => 'vk',
    :fb => 'fb'
  }

  VK_PARAMS = %w(
    api_url api_id api_settings viewer_id
    viewer_type sid secret access_token
    user_id group_id is_app_user auth_key
    language parent_language ad_info
    is_secure ads_app_id referrer lc_name hash
  )

  OK_PARAMS = %w(
    authorized ip_geo_location api_server
    new_sig apiconnection first_start
    clientLog session_secret_key
    application_key auth_sig web_server
    session_key logged_user_id sig
  )

  class << self

    def social_params(params)
      params.slice(VK_PARAMS + OK_PARAMS)
    end

    def social_request?(params)
      request_social_type(params).present?
    end

    def request_social_type(params)
      if social_env = (params[:social_env])
        # Если параметр задается с помощью RackBuilder
        # через SocialPrefix и передается как social_env
        # через параметры приложения
        params[:social_env][:type]
      else
        params_social_type(params)
      end
    end

    # Определяем тип социальной сети по параметрам
    # первоначального запроса. Например если передан параметр
    # viewer_id и sid, то это Вконтакте
    def params_social_type(params)
      case 
      when params[:viewer_id].present? && params[:sid].present? then :vk
      when params[:logged_user_id].present? && params[:session_key].present? then :ok
      else
        nil
      end
    end

    def request_session_token(params)
      case request_social_type(params)
      when :vk then "vk::#{params[:sid]}"
      when :ok then "ok::#{params[:session_key]}"
      else
        raise 'Not defined social type'
      end
    end

    def request_uid(params)
      case request_social_type(params)
      when :vk then "vk::#{params[:user_id]}"
      when :ok then "ok::#{params[:logged_user_id]}"
      else
        raise 'Not defined social type'
      end
    end

    def Network(network, params = nil)
      raise 'Not set network' unless network

      unless SOCIAL_TYPES.values.include?(network.to_sym)
        raise "Can`t find network type: #{network}"
      end

      Social::Networks.instance.site(network.to_sym, params)
    end

    def type_by_id(id = nil)
      id ||= 1
      SOCIAL_TYPES[id.to_i]
    end

    def id_by_type(type = nil)
      type ||= 'ok'
      SOCIAL_TYPES.detect { |id, t| t == type.to_sym }.first
    end

    def type_by_prefix(prefix)
      SOCIAL_PREFIX.detect { |type, pref| pref == prefix.to_s }.first
    end

    def id_by_prefix(prefix)
      id_by_type(type_by_prefix(prefix))
    end

    def prefix_by_type(type)
      SOCIAL_PREFIX[type]
    end

    def type_codes
      SOCIAL_TYPES.values
    end

    def type_ids
      SOCIAL_TYPES.keys
    end

    def type_prefixes
      SOCIAL_PREFIX.values
    end

  end

end
