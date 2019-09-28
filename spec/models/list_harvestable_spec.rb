require 'rails_helper'

RSpec.describe ListHarvestable, type: :model do
  before(:each) do
  	@user = User.create(email: "abcd1234@emails.com", password: "abcd1234")
  	@list = List.create(user: @user, list_name: "Test List")
  	@listharvestable = ListHarvestable.create(list: @list)
  end

  it "returns the generic list that it is a harvestable version of" do
  	expect(@listharvestable.list).to equal(@list)
  end

  it "returns the user that owns that generic list" do
  	expect(@listharvestable.user).to eq(@user)
  end

  it "can only have one harvestable version of a list" do
  	@listharvestable2 = ListHarvestable.new(list: @list)
  	@listharvestable2.valid?
  	expect(@listharvestable2.errors[:list]).not_to eq([])
  end

  it "is not valid without a list" do
  	@listharvestable.list = nil
  	@listharvestable.valid?
  	expect(@listharvestable.errors[:list]).not_to eq([])
  end
end
