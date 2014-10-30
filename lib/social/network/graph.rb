module Social::Network::Graph

  attr_reader :graph

  def method_missing(name, *args)
    return @graph[name] if @graph && @graph[name]
    super
  end
  

  protected

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
