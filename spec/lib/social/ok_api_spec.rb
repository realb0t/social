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

      mock(@api.user).deliver(params).times(3) { [] }
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

      mock(@api.user).deliver(params).times(3) { [] }
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

      mock(@api.user).deliver(params) { [] }
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

      mock(@api.user).deliver(params) { [] }
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

      mock(@api.user).deliver(params) { [] }
      @api.user.get_info(@uids, { :secret => @secret, :fields => uncorrect_fields })
    end

    it "вызов с неопределенными опциями" do
      params = {
        "method" => 'users.getInfo',
        "fields" => Social::Network::Graph::Ok::User::FIELDS,
        :uids => @uids.join(",")
      }

      mock(@api.user).deliver(params) { [] }
      @api.user.get_info(@uids, nil)
    end

    it "вызов с пустыми опциями" do
      params = {
        "method" => 'users.getInfo',
        "fields" => Social::Network::Graph::Ok::User::FIELDS,
        :uids => @uids.join(",")
      }

      mock(@api.user).deliver(params) { [] }
      @api.user.get_info(@uids, {})
    end

    it "данные по пользователю должны возвращаться в известном формате" do
      data = @make_fake_datas.call(1)
      stub(@api.user).http_query { [200, data.to_json] }
      results = @api.user.get_info(1234567890)
      results.should be_a_kind_of Array
      results.first.should be_a_kind_of Hash
      results.should == JSON.load(data.to_json)
    end
    
  end
end