class Social::Network::Ok
  include Singleton
  include Social::Network::Base
  include Social::Config::Ok
  
  def rate
    1
  end

  def initialize(params = nil)
    
    #require File.join(File.dirname(__FILE__), 'graph', 'ok', 'user')
    #require File.join(File.dirname(__FILE__), 'graph', 'ok', 'notification')
    
    super('ok', [ :user, :notification ], params)
  end
end
