module Social
  class Builder < Rack::Builder
    def self.produce(app)
      new do

        map '/' do
          run app
        end

        Social.type_prefixes.each_with_index do |prefix, index|

          map '/' + prefix do
            use Social::Provider.build(prefix)
            run app
          end

        end

      end
    end
  end
end