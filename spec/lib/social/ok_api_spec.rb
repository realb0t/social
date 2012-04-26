# encoding: utf-8
require 'spec_helper'

describe 'Спецификация OkApi' do

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
    
  end
end