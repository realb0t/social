module Social
  module Network
    module Graph
      module Vk
        class Notification < Social::Network::Graph::Vk::Base
          
          def send(options = {})
            params = { "method" => 'secure.sendNotification', :uids => options[:uids], :message => options[:message] }
            result = self.process_secure(params)
            
            #result = deliver('method' => 'secure.sendNotification', 'text' => options[:message], 'uid' => options[:uids])
            
            return result unless block_given?
            yield(result) if block_given?
          end
          
        end
      end
    end
  end
end
