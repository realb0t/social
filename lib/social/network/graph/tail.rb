module Social
  module Network
    module Graph
      module Tail
        
        def root=(root_instance)
          @root = root_instance
        end
        
        protected
        
          def rate
            root.rate
          end
          
          def root
            @root
          end
    
      end
    end
  end
end