module Social
  module Network
    module Graph
      module Ok
        class User < Social::Network::Graph::Ok::Base
          
          FIELDS = 'uid,first_name,last_name,gender,birthday,pic_1,pic_2,pic_3,pic_4,url_profile,location,current_location,age,url_profile,current_status'
          
          def get_info(uids, secret = nil, options = nil)
            fields = Array.wrap(options.try(:[], :fields)).join(',')
            fields = fields.present? ? fields : FIELDS
            
            params = { "method" => 'users.getInfo', "fields" => fields, 
              :uids => Array.wrap(uids).join(","), :session_secret_key => secret }
            response = self.send(:deliver, params)
            result = response.present? ? MultiJson.load(response.body) : []
            result = result.is_a?(Hash) && result['error_msg'] ? nil : result
            
            return result unless block_given?
            yield(result) if block_given?
          end
          
          def get_friends(uid, secret = nil)
            params = { "method" => 'friends.get', :uid => uid, :session_secret_key => secret }
            response = self.send(:deliver, params)
            
            result = (response.present? && response != true) ? ActiveSupport::JSON.decode(response.body) : []
            result = (result.is_a?(Hash) && result['error_msg']) ? [] : result # if returned failure

            return result unless block_given?
            yield(result) if block_given?
          end

          def get_friends_profiles(uid, secret = nil, options = nil)
            friend_uids = get_friends_uids(uid, secret)
            friend_profiles = friend_uids.map { |uid| get_info(uid, secret, options) }.flatten.compact
            
            return friend_profiles unless block_given?
            yield(friend_profiles) if block_given?
          end
          
          alias :get_friends_uids :get_friends
          alias :get_friends_info :get_friends_profiles
          
        end
      end
    end
  end
end
