require 'singleton'

require 'active_support/all'
require 'rack'

require 'social/version'
require 'social/provider'
require 'social/builder'
require 'social/cache'
require 'social/config/vk'
require 'social/config/ok'
require 'social/config'
require 'social/env'
require 'social/helper/controller'
require 'social/helper/model'
require 'social/helper'
require 'social/auth/controller'
require 'social/auth'
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

  class << self

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
