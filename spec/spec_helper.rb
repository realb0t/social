require "bundler"
Bundler.require :default, :development

RSpec.configure do |config|
  config.mock_with :rr
end
