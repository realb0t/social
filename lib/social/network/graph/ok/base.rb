module Social
  module Network
    module Graph
      module Ok
        class Base
          
          include Social::Network::Graph::Tail
          include Social::Config::Ok

          def normalize_msg(msg)
            [ ['&nbps;', ' '],
              ['&mdash;', '-'],
              ['&', ''],
              ['%', '']
            ].each { |rep| msg.gsub!(*rep) }
            msg
          end

          def deliver(params)
            url = URI.parse(config['api_server'])
            retries = 0
            begin
              res = Net::HTTP.start(url.host, url.port) { |http|
                http.read_timeout = 10
                request_params = build_request_params(params)
                http.get("/fb.do?#{Rack::Utils.universal_build(request_params)}")
              }
            rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
              retries += 1
              retry if retries < 3
            end
  
            rescue => e
              #Rails.logger.warn "Send problem"
              #Rails.logger.warn params.inspect
              #Rails.logger.warn e.inspect
            ensure
            res
          end

          def build_sig(params, key)
            params_to_sign_string = params.keys.inject([]) {|m,e| m << "#{e}=#{params[e]}"}.sort.join
            Digest::MD5.hexdigest(params_to_sign_string + key)
          end

          def build_request_params(params = {})
            params.merge!({ :format => "JSON", :application_key => config[:application_key]})
            key = params.delete(:session_secret_key) || config[:secret_key]
            params[:sig] = build_sig(params, key)
            params
          end

        end
      end
    end
  end
end
