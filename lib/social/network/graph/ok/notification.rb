module Social
  module Network
    module Graph
      module Ok
        class Notification < Social::Network::Graph::Ok::Base
          
          def send(options = {})
            result = deliver('method' => 'notifications.sendSimple', 'text' => options[:message], 'uid' => options[:uids])
            
            return result unless block_given?
            yield(result) if block_given?
          end
          
        end
      end
    end
  end
end
