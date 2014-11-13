module Social
  class Networks
    include Singleton

    def initialize()
      @domains = {}
    end

    def site(network, params)
      @domains[network.to_sym] ||= deploy(network)
      @domains[network.to_sym].params = params || {}
      @domains[network.to_sym].reload_config
      @domains[network.to_sym]
    end

    protected
      
      def deploy(network)
        network_name = network.to_s.classify
        if Social::Network.const_defined?(network_name)
          @network = Social::Network.const_get(network_name).instance
        else
          @network = Social::Network::Stub.instance
        end
      end
  end
end
