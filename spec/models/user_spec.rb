require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
  	@user = User.create(email: "email@emails.com", password: "abcd1234")
  end

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
end
