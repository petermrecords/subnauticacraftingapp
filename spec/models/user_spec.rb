require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
  	@user = User.create(email: "email@emails.com", password: "abcd1234")
  end

  context "minimum requirements" do
    it "is valid so long as it has an email and a password" do
    	expect(@user.valid?).to eq(true)
    end

    it "is invalid without an email" do
    	@user.email = nil
    	@user.valid?
    	expect(@user.errors[:email]).not_to eq([])
    end

    it "is invalid with a duplicate email" do
    	@user2 = User.create(email: "email@emails.com", password: "qwertyiou")
    	@user2.valid?
    	expect(@user2.errors[:email]).not_to eq([])
    end

    it "is invalid without a password" do
      @user.password = nil
      @user.valid?
      expect(@user.errors[:password]).not_to eq([])
    end

    it "must have a password 6 characters or longer" do
      @user.password = "a"
      @user.valid?
      expect(@user.errors[:password]).not_to eq([])
    end
  end

  context "owns lists" do
    before(:each) do
      @list = List.create(user: @user, list_name: "Test List")
      @list2 = List.create(user: @user, list_name: "Test List II")
    end

    it "can have many lists and returns the lists that it owns" do
      expect(@user.lists).to include(@list, @list2)
    end

    it "can access the carryable version of lists it owns" do
      @listcarryable = ListCarryable.find_by(list: @list)
      @user = User.first
      expect(@user.list_carryables).to include(@listcarryable)
    end

    it "can access the harvestable version of lists it owns" do
      @listharvestable = ListHarvestable.find_by(list: @list)
      @user = User.first
      expect(@user.list_harvestables).to include(@listharvestable)
    end
  end
end
