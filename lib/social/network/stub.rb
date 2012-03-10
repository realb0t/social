module Social
  module Network
    class Stub
      include Singleton
      include Social::Network::Graph
      include Social::Network::Params
    end
  end
end
