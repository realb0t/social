module Social
  module Network
    module Base

      include Social::Network::Graph
      include Social::Network::Params

      def initialize(root, list, params = nil)
        init_params(params)
        init_graph_for(root, list)
      end
    end
  end
end
