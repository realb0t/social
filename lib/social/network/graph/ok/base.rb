module Rack
  module Utils # :nodoc:

    def universal_build(value, prefix = nil)
      case value.class.to_s
      when Array.to_s
        value.map do |v|
          unless unescape(prefix) =~ /\[\]$/
            prefix = "#{prefix}[]"
          end
          universal_build(v, "#{prefix}")
        end.join("&")
      when Hash.to_s
        value.map do |k, v|
          universal_build(v, prefix ? "#{prefix}[#{escape(k)}]" : escape(k))
        end.join("&")
      when NilClass.to_s
        prefix.to_s
      else
        "#{prefix}=#{escape(value.to_s)}"
      end
    end

    module_function :universal_build
  end
end

module Social::Network::Graph::Ok
  class Base
    
    include Social::Network::Graph::Tail

    def config
      Social::Network(:ok).config
    end

    def normalize_msg(msg)
      [ ['&nbps;', ' '],
        ['&mdash;', '-'],
        ['&', ''],
        ['%', '']
      ].each { |rep| msg.gsub!(*rep) }
      msg
    end

    def http_query(query)
      result = []
      url = URI.parse(config['api_server'])
      retries = 0
      result = Net::HTTP.start(url.host, url.port) { |http|
        http.read_timeout = 10
        http.get(query)
      }
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      retries += 1
      retry if retries < 3
    ensure
      result
    end

    def deliver(params)
      result = []
      request_params = build_request_params(params)
      query = "/fb.do?#{Rack::Utils.universal_build(request_params)}"
      result = self.http_query(query)
    rescue => e
      puts "====== Send problem"
      puts params.inspect
      puts e.to_s
      puts e.backtrace
    ensure
      result
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
