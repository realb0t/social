require 'spec_helper'

describe Social do

  it "support ok" do
    Social::Network(:ok).user.should_not be_nil
    Social::Network(:ok).rate.should_not be_nil
  end

  it "support vk" do
    Social::Network(:vk).user.should_not be_nil
    Social::Network(:vk).rate.should_not be_nil
  end

  it "must load config to vk" do
  	Social::Network(:vk).config.should_not be_nil
    Social::Network(:vk).config['key'].should_not be_nil
    Social::Network(:vk).config['app_id'].should_not be_nil
  end

  it "must load config to vk" do
    Social::Network(:ok).config.should_not be_nil
    Social::Network(:ok).config['api_server'].should_not be_nil
    Social::Network(:ok).config['application_key'].should_not be_nil
    Social::Network(:ok).config['secret_key'].should_not be_nil
  end
end