class Social::Network::Base

  include Singleton

  attr_reader :graph

  def method_missing(name, *args)
    return @graph[name] if @graph && @graph[name]
    super
  end

  def initialize(root, list, params = nil)
    init_params(params)
    init_graph_for(root, list)
  end

  def params
    @params
  end

  def params!(params)
    @params = params
    self
  end

  def param(key)
    @params[key]
  end

  def param!(key, value)
    @params[key] = value
    self
  end

  protected

  def init_params(params)
    @params = params.is_a?(Hash) ? params : {}
  end

  def init_graph_for(graph_name, graphs)
    
    graph_root = Social::Network::Graph.const_get(graph_name.to_s.classify)
    
    generated_graphs = graphs.map do |space|
       
      namespace = space.to_s.classify
      
      begin
        graph_root.const_get(namespace) # try load
        
        graph_tail      = graph_root.const_get(namespace).new
        graph_tail.root = self
        
        [space, graph_tail]
      rescue NameError
        nil
      end
      
    end
    
    @graph = Hash[generated_graphs.compact]
  end 

end
