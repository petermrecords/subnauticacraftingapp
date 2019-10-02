require 'rails_helper'

RSpec.describe List, type: :model do
  before(:each) do
  	@user = User.create(email: "abcd1234@emails.com", password: "abcd1234")
  	@list = List.create(user: @user, list_name: "Test List")
  end

  context "minimum requirements" do
    it "can be created with just a user and a name" do
    	expect(List.first).to eq(@list)
    end

    it "can have some notes about itself" do
    	@list.list_notes = "Some bullshit text to test this feature"
    	expect(@list.list_notes).not_to eq(nil)
    end

    it "is invalid without any materials after it has been created" do
      @list.valid?
      expect(@list.errors[:list_materials]).not_to eq([])
    end
  end

  context "owned by a user" do
    it "returns its owner" do
      expect(@list.user).to equal(@user)
    end

    it "is deleted when its owner deletes their account" do
      @user.destroy
      expect(List.all.empty?).to eq(true)
    end
  end
  
  context "interacts with materials" do
    before(:each) do
      @material = Material.create({
        material_name: "Listed Material",
        material_type: "Test Type"
      })
      @list.list_materials.create(material: @material, number_desired: 1)
    end

    it "is valid so long as it includes an owner, a name and one material" do
      expect(@list.valid?).to eq(true)
    end

    it "can have more than one material and return the whole set" do
      @material2 = Material.create({
        material_name: "Test Material II",
        material_type: "Test Type"
      })
      @list.list_materials.create(listable: @list, material: @material2, number_desired: 1)
      expect(@list.materials).to include(@material, @material2)
    end

    it "returns the number of a given material desired when that material is included" do
      expect(@list.how_many_of(@material)).to eq(1)
    end

    it "returns 0 when a given material is not included on the list" do
      @material2 = Material.create({
        material_name: "Test Material II",
        material_type: "Test Type"
      })
      expect(@list.how_many_of(@material2)).to eq(0)
    end
  end

  context "has a carryable version of itself" do
  	it "returns a single carryable version of itself, autocreated when it is created" do
  		expect(@list.list_carryable).to be_a(ListCarryable)
  	end

    it "deletes the carryable version of itself when it is deleted" do
      @list.destroy
      expect(ListCarryable.all.empty?).to eq(true)
    end
  end

  context "has a harvestable version of itself" do
  	it "returns a single harvestable version of itself, autocreated when it is created" do
  		expect(@list.list_harvestable).to be_a(ListHarvestable)
  	end

    it "deletes the harvestable version of itself when it is deleted" do
      @list.destroy
      expect(ListHarvestable.all.empty?).to eq(true)
    end
  end
end
