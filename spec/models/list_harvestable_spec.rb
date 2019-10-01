require 'rails_helper'

RSpec.describe ListHarvestable, type: :model do
  before(:each) do
  	@user = User.create(email: "abcd1234@emails.com", password: "abcd1234")
  	@list = List.create(user: @user, list_name: "Test List")
  	@listharvestable = ListHarvestable.create(list: @list)
  end

  context "minimum requirements" do
    it "can be created with just a related list" do
      expect(ListHarvestable.first).to eq(@listharvestable)
    end

    it "is not valid without a list" do
      @listharvestable.list = nil
      @listharvestable.valid?
      expect(@listharvestable.errors[:list]).not_to eq([])
    end

    it "is invalid without materials once it has been created" do
      @listharvestable.valid?
      expect(@listharvestable.errors[:list_materials]).not_to eq([])
    end
  end


  context "interacts with a generic list" do
    it "returns the generic list that it is a harvestable version of" do
    	expect(@listharvestable.list).to eq(@list)
    end

    it "returns the user that owns that generic list" do
    	expect(@listharvestable.user).to eq(@user)
    end

    it "can only have one harvestable version of a list" do
    	@listharvestable2 = ListHarvestable.new(list: @list)
    	@listharvestable2.valid?
    	expect(@listharvestable2.errors[:list]).not_to eq([])
    end
  end

  context "interacts with materials" do
    before(:each) do
      @material = Material.create({
        material_name: "Listed Material",
        material_type: "Test Type"
      })
      @listharvestable.list_materials.create(material: @material, number_desired: rand(9999) + 1)
    end

    it "is valid with an associated list and one material" do
      expect(@listharvestable.valid?).to eq(true)
    end

    it "can have more than one material and returns the whole set" do
      @material2 = Material.create({
        material_name: "Listed Material II",
        material_type: "Test Type"
      })
      @listharvestable.list_materials.create(listable: @listharvestable, material: @material2, number_desired: rand(9999) + 1)
      @listharvestable = ListHarvestable.first # reload the object to get the :through association
      expect(@listharvestable.materials).to include(@material, @material2)
    end

    it "is invalid with a crafted material attached" do
      @material2 = Material.create({
        material_name: "Crafted Material",
        material_type: "Test Type"
      })
      @blueprint = Blueprint.create({
        material_produced: @material2,
        material_required: @material,
        number_required: rand(9999) + 1
      })
      @material2.update(crafted_at: "Fabricated", number_produced: 1)
      @material2.save
      @listharvestable.list_materials.create(material: @material2, number_desired: 1)
      @listharvestable = ListHarvestable.first # reload the object to get the :through association
      @listharvestable.valid?
      expect(@listharvestable.errors[:materials]).not_to eq([])
    end

    it "returns the number of a given material desired when that material is included" do
      expect(@listharvestable.how_many_of(@material)).to eq(1)
    end

    it "returns 0 when a given material is not included on the list" do
      @material2 = Material.create({
        material_name: "Test Material II",
        material_type: "Test Type"
      })
      expect(@listharvestable.how_many_of(@material2)).to eq(0)
    end
  end
end
