require 'rails_helper'

RSpec.describe ListCarryable, type: :model do
  before(:each) do
  	@user = User.create(email: "abcd1234@emails.com", password: "abcd1234")
  	@list = List.create(user: @user, list_name: "Test List")
  	@listcarryable = ListCarryable.create(list: @list)
  end

  it "returns the generic list that it is a carryable version of" do
  	expect(@listcarryable.list).to equal(@list)
  end

  it "returns the user that owns that generic list" do
  	expect(@listcarryable.user).to eq(@user)
  end

  it "can only have one carryable version of a list" do
  	@listcarryable2 = ListCarryable.new(list: @list)
  	@listcarryable2.valid?
  	expect(@listcarryable2.errors[:list]).not_to eq([])
  end

  it "is not valid without a list" do
  	@listcarryable.list = nil
  	@listcarryable.valid?
  	expect(@listcarryable.errors[:list]).not_to eq([])
  end
end
