require 'singleton'
require 'active_support/all'
require 'rack'
require 'social/version'
require 'social/provider'
require 'social/builder'
require 'social/config/vk'
require 'social/config/ok'
require 'social/config'
require 'social/env'
require 'social/network/graph/tail'
require 'social/network/params'
require 'social/network/base'
require 'social/network/graph'
require 'social/network/ok'
require 'social/network/vk'
require 'social/network/graph/ok/base'
require 'social/network/graph/ok/notification'
require 'social/network/graph/ok/user'
require 'social/network/graph/ok'
require 'social/network/graph/vk/base'
require 'social/network/graph/vk/notification'
require 'social/network/graph/vk/user'
require 'social/network/graph/vk'
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
      if params[:social_env]
        params[:social_env][:type]
      else
        case 
        when params[:viewer_id].present? && params[:sid].present? then :vk
        when params[:logged_user_id].present? && params[:session_key].present? then :ok
        else
          nil
        end
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

    def current_id=(id)
      @id = id
    end

    def current_id
      @id
    end
    
    def current_type=(type)
      @type = type
    end

    def current_type
      @type
    end

    def current_prefix=(prefix)
      @prefix = prefix
    end

    def current_prefix
      @prefix
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

    def typing(index)
      return type_by_id(index) if SOCIAL_TYPES.keys.include?(index.to_i)
      return index.to_sym if SOCIAL_TYPES.values.include?(index.to_sym)
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
