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

end