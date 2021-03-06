module Social::Network::Graph::Vk
  class User < Base
          
    FIELDS = 'uid,first_name,last_name,nickname,domain,sex,birthdate,city,country,timezone,photo,photo_medium,photo_big,has_mobile,rate,contacts,education'
    
    def get_info(*args)
      uids = Array.wrap(args)
      
      params = { "method" => 'getProfiles', "fields" => FIELDS, :uids => uids.join(",")}
      
      results = send(:process, params)

      results.each_with_index { |result, i|
        results[i]['birthday'] = result['bdate'] || result['birthday']
      }
      
      return results unless block_given?
      yield(results) if block_given?
    end
    
    def get_friends(uid)
      throw 'Not give uid for friends request' unless uid

      params = { "method" => 'friends.get', :uid => uid, "fields" => FIELDS}
      result = send(:process_secure, params)

      return result unless block_given?
      yield(result) if block_given?
    end
    
    def get_friends_profiles(uid)
      
      friend_uids = get_friends_uids(uid)
      friend_profiles = friend_uids.map { |uid| get_info(uid) }.flatten.compact
      
      return friend_profiles unless block_given?
      yield(friend_profiles) if block_given?
    end

    def charge_off_balance(uid, balance)
      amount = (((balance).floor / root.rate.to_f).round(2) * 100).round
      params = { "method" => 'secure.withdrawVotes', :uid => uid, :votes => amount }
      result = send(:process_secure, params)
      
      return result unless block_given?
      yield(result) if block_given?
    end

    def balance(uid)
      throw 'Not give uid for balance request' unless uid

      params = { "method" => 'secure.getBalance', :uid => uid }
      result = send(:process_secure, params)
      result = ((result / 100).to_f.round(2) * root.rate)
      
      return result unless block_given?
      yield(result) if block_given?
    end
    
    alias :get_friends_uids :get_friends
    alias :get_friends_info :get_friends_profiles

  end
end
