require 'rails_helper'

RSpec.describe List, type: :model do
  before(:each) do
  	@user = User.create(email: "abcd1234@emails.com", password: "abcd1234")
  	@list = List.create(user: @user, list_name: "Test List")
  end

  it "is valid so long as it has a user and a name" do
  	expect(@list.valid?).to eq(true)
  end

  it "can have some notes about itself" do
  	@list.list_notes = "Some bullshit text to test this feature"
  	expect(@list.list_notes).not_to eq(nil)
  end

  it "returns its owner" do
  	expect(@list.user).to equal(@user)
  end

  context "attached to a carryable version" do
  	before(:each) do
  		@listcarryable = ListCarryable.create(list: @list)
  	end

  	it "returns a single carryable version of itself" do
  		expect(@list.list_carryable).to equal(@listcarryable)
  	end
  end

  context "attached to a harvestable version" do
  	before(:each) do
  		@listharvestable = ListHarvestable.create(list: @list)
  	end

  	it "returns a single harvestable version of itself" do
  		expect(@list.list_harvestable).to equal(@listharvestable)
  	end
  end
end
