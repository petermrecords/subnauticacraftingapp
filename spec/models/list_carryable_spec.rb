require 'rails_helper'

RSpec.describe ListCarryable, type: :model do
  before(:each) do
  	@user = User.create(email: "abcd1234@emails.com", password: "abcd1234")
  	@list = List.create(user: @user, list_name: "Test List")
  	@listcarryable = ListCarryable.create(list: @list)
  end

  context "minimum requirements" do
    it "can be created with just a related list" do
      expect(ListHarvestable.first).to eq (@listharvestable)
    end

    it "is not valid without a list" do
      @listcarryable.list = nil
      @listcarryable.valid?
      expect(@listcarryable.errors[:list]).not_to eq([])
    end

    it "is invalid without materials once it has been created" do
      @listcarryable.valid?
      expect(@listcarryable.errors[:list_materials]).not_to eq([])
    end
  end

  context "interacts with a generic list" do
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
  end

  context "interacts with materials" do
    before(:each) do
      @material = Material.create({
        material_name: "Listed Material",
        material_type: "Test Type",
        inventory_spaces: rand(9999) + 1
      })
      @listcarryable.list_materials.create(material: @material, number_desired: rand(9999) + 1)
    end

    it "is valid with an associated list and one material" do
      expect(@listcarryable.valid?).to eq(true)
    end

    it "can have more than one material and returns the whole set" do
      @material2 = Material.create({
        material_name: "Listed Material II",
        material_type: "Test Type",
        inventory_spaces: rand(9999) + 1
      })
      @listcarryable.list_materials.create(material: @material2, number_desired: rand(9999) + 1)
      @listcarryable = ListCarryable.first
      expect(@listcarryable.materials).to include(@material, @material2)
    end

    it "is invalid with a non-carryable material attached" do
      @material.inventory_spaces = nil
      @material.save
      @listcarryable = ListCarryable.first
      @listcarryable.valid?
      expect(@listcarryable.errors[:materials]).not_to eq([])
    end

    it "returns the number of a given material desired when that material is included" do
      expect(@listcarryable.how_many_of(@material)).to eq(1)
    end

    it "returns 0 when a given material is not included on the list" do
      @material2 = Material.create({
        material_name: "Test Material II",
        material_type: "Test Type"
      })
      expect(@listcarryable.how_many_of(@material2)).to eq(0)
    end
  end
end
