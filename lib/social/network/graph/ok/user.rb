module Social
  module Network
    module Graph
      module Ok
        class User < Social::Network::Graph::Ok::Base
          
          FIELDS = 'uid,first_name,last_name,gender,birthday,pic_1,pic_2,pic_3,pic_4,url_profile,location,current_location,age,url_profile,current_status'
          
          def get_info(*args)

            args.pop if args.last.nil?

            if args.last.kind_of?(Hash)
              options = args.pop #.with_indefferend_access
              secret = options[:secret]
              fields = options[:fields]
              
              fields = fields.join(',') if fields.kind_of?(Array)
              
              if fields
                avalible_fields = FIELDS.split(',')
                fields = fields.split(',').select { |field| 
                  avalible_fields.include?(field)
                }.sort.join(',')
                fields = nil if fields.empty?
              end
            end

            uids = Array.wrap(args)
            params = { "method" => 'users.getInfo', "fields" => (fields || FIELDS), 
              :uids => uids.join(",") }
            params[:session_secret_key] = secret if secret

            code, response = self.deliver(params)
            result = response.present? ? MultiJson.load(response) : { 'error_msg' => 'Empty response' }
            result = result.is_a?(Hash) && result['error_msg'] ? [] : result['response']
            
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

          def charge_off_balance(uid, balance)
            return [] unless block_given?
            yield([]) if block_given?
          end

          def balance(uid)
            return nil unless block_given?
            yield(nil) if block_given?
          end
          
          alias :get_friends_uids :get_friends
          alias :get_friends_info :get_friends_profiles
          
        end
      end
    end
  end
end
