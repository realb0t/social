require 'spec_helper'

describe 'Config' do

  before do
    @vk_api = Social::Network(:vk)
    @ok_api = Social::Network(:ok)  
  end

  it "must load config to vk" do
    @vk_api.config.should_not be_nil
    @vk_api.config['key'].should_not be_nil
    @vk_api.config['app_id'].should_not be_nil
  end

  it "must load config to ok" do
    @ok_api.config.should_not be_nil
    @ok_api.config['api_server'].should_not be_nil
    @ok_api.config['application_key'].should_not be_nil
    @ok_api.config['secret_key'].should_not be_nil
  end

  it "valid safe config data for vk" do
    avalible_keys = [ :app_id , :logged_user_id ]
    @vk_api.safe_config.keys.should =~ avalible_keys
  end

  it "valid safe config data for ok" do
    avalible_keys = [ :api_server , :application_key, :logged_user_id ]
    @ok_api.safe_config.keys.should =~ avalible_keys
  end
end