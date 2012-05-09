module Social
  module Network
    module Graph
      module Vk
        class Base
          
          include Social::Network::Graph::Tail
          include Social::Config::Vk

          def http_query(query)
            Net::HTTP.start("api.vkontakte.ru", 80).get(query)
          end

          def process(params)
            params = default_options.merge(params).with_indifferent_access
            params.merge!({'sig' => form_signature(params)})
            query = "/api.php?#{Rack::Utils.build_query(params)}"
            status, data = http_query(query)
            JSON.load(data)['response']
          end

          def process_secure(params)
            process(params.merge('random' => (rand * 10_000).to_i, 'timestamp' => Time.now.to_i))
          end

          private
          
            def default_options
              {:v => '3.0', :format  => 'JSON', :api_id => config['app_id'] }
            end

            def form_signature(params)
              str = params.sort.map{|pair| "#{pair[0]}=#{pair[1]}"}.join('') + config['key']
              Digest::MD5.hexdigest(str)
            end

        end
      end
    end
  end
end
