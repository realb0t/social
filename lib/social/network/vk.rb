class Social::Network::Vk
  include Singleton
  include Social::Network::Base
  include Social::Config::Vk
  
  def rate
    6
  end

  def initialize(params = nil)
    
    #require File.join(File.dirname(__FILE__), 'graph', 'vk', 'user')
    #require File.join(File.dirname(__FILE__), 'graph', 'vk', 'notification')
    
    super('vk', [ :user, :notification ], params)
  end
end
