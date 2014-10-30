module Social::Network::Graph::Ok
  class Notification < Base
    
    def send(options = {})
      result = deliver('method' => 'notifications.sendSimple', 'text' => options[:message], 'uid' => options[:uids])
      
      return result unless block_given?
      yield(result) if block_given?
    end
    
  end
end
