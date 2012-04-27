# encoding: utf-8
require 'spec_helper'

describe 'Спецификация OkApi' do

  context "функция user.get_info" do

    before do
      @api = Social::Network(:ok)

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

      @uids = [ 1,2,3,4 ]
      @secret = 'session_secret_key'
      @fields = [ 'uid', 'first_name', 'last_name' ]

    end


    it "вне зависимости от способа передачи uids запрос должен формироваться стандартно" do
      params = {
        "method" => 'users.getInfo', 
        "fields" => Social::Network::Graph::Ok::User::FIELDS, 
        :uids => @uids.join(",")
      }

      @api.user.should_receive(:deliver).with(params).exactly(3).and_return([])
      @api.user.get_info(*@uids)
      @api.user.get_info(@uids)
      @api.user.get_info([@uids])
    end

    it "передача сессионного secret_key" do

      params = {
        "method" => 'users.getInfo', 
        "fields" => Social::Network::Graph::Ok::User::FIELDS, 
        :uids => @uids.join(","),
        :session_secret_key => @secret
      }

      @api.user.should_receive(:deliver).with(params).exactly(3).and_return([])
      @api.user.get_info(@uids, { :secret => @secret })
      @api.user.get_info([@uids], { :secret => @secret })
      @api.user.get_info(*@uids, { :secret => @secret })
    end

    it "передача полей" do

      params = {
        "method" => 'users.getInfo', 
        "fields" => @fields.sort.join(','),
        :uids => @uids.join(","),
        :session_secret_key => @secret
      }

      @api.user.should_receive(:deliver).with(params).exactly(1).and_return([])
      @api.user.get_info(@uids, { :secret => @secret, :fields => @fields })
    end

    it "передача некоторых не корректных полей" do

      params = {
        "method" => 'users.getInfo', 
        "fields" => @fields.sort.join(','),
        :uids => @uids.join(","),
        :session_secret_key => @secret
      }

      uncorrect_fields = @fields + [ "uncorrect_field 1", "uncorrect_field 2" ]

      @api.user.should_receive(:deliver).with(params).exactly(1).and_return([])
      @api.user.get_info(@uids, { :secret => @secret, :fields => uncorrect_fields })
    end

    it "передача всех не корректных полей" do

      params = {
        "method" => 'users.getInfo',
        "fields" => Social::Network::Graph::Ok::User::FIELDS,
        :uids => @uids.join(","),
        :session_secret_key => @secret
      }

      uncorrect_fields = [ "uncorrect_field 1", "uncorrect_field 2" ]

      @api.user.should_receive(:deliver).with(params).exactly(1).and_return([])
      @api.user.get_info(@uids, { :secret => @secret, :fields => uncorrect_fields })
    end

    
  end
end