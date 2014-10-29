# encoding: utf-8
require 'spec_helper'

describe 'Спецификация VkApi' do

  context "функция user.get_info" do

    before do
      @api = Social::Network(:vk)

      fake_data_index = 1
      @make_fake_data = lambda do
        fake_data_index += 1

        return {
          :nickname => "fake data #{fake_data_index}",
          :first_name => "fake data #{fake_data_index}",
          :last_name => "fake data #{fake_data_index}",
          :location => "fake data #{fake_data_index}",
          :location => "fake data #{fake_data_index}",
          :birthday => "fake data #{fake_data_index}",
          :url_profile => "fake data #{fake_data_index}",
          :pic_1 => "fake data #{fake_data_index}",
          :gender => "fake data #{fake_data_index}"
        }
      end

      @make_fake_datas = lambda do |quantity|
        datas = []
        quantity.times { datas.push(@make_fake_data.call) }
        datas
      end 

    end

    it "вне зависимости от способа передачи uids запрос должен формироваться стандартно" do
      uids = [ 1,2,3,4 ]
      params = { 
        "method" => 'getProfiles', 
        "fields" => Social::Network::Graph::Vk::User::FIELDS, 
        :uids    => uids.join(',')
      }

      mock(@api.user).process(params).times(3) { [] }
      @api.user.get_info(*uids)
      @api.user.get_info(uids)
      @api.user.get_info([uids])
    end


    it "данные по пользователю должны возвращаться в известном формате" do
      data = @make_fake_datas.call(1)
      stub(@api.user).http_query { [200, { :response => data }.to_json] }
      results = @api.user.get_info(1234567890)
      results.should be_a_kind_of Array
      results.first.should be_a_kind_of Hash
      results.should == JSON.load(data.to_json)

    end

  
  end

end