require "rails_helper"

RSpec.describe Material, type: :model do
  before(:each) do
    @material = Material.create({
      material_name: "Test Material I",
      material_type: "Test Type"
    })
  end

  # validations
  it "is valid so long as it has both a name and a type" do
    expect(@material.valid?).to eq(true)
  end

  it "is invalid without a name" do
    @material.material_name = nil
    @material.valid?
    expect(@material.errors[:material_name]).not_to eq([])
  end

  it "is invalid with a duplicate name" do
    @material2 = Material.create({
      material_name: "Test Material I",
      material_type: "Test Type"
    })
    @material2.valid?
    expect(@material2.errors[:material_name]).not_to eq([])
  end

  it "is invalid without a type" do
    @material.material_type = nil
    @material.valid?
    expect(@material.errors[:material_type]).not_to eq([])
  end

  it "is valid with a positive number of inventory spaces" do
    @material.inventory_spaces = 1
    expect(@material.valid?).to eq(true)
  end

  it "is invalid with 0 inventory spaces" do
    @material.inventory_spaces = 0
    @material.valid?
    expect(@material.errors[:inventory_spaces]).not_to eq([])
  end

  it "is invalid with a negative number of inventory spaces" do
    @material.inventory_spaces = -1
    @material.valid?
    expect(@material.errors[:inventory_spaces]).not_to eq([])
  end

  it "is valid with a positive number of growbed spaces" do
    @material.growbed_spaces = 1
    expect(@material.valid?).to be true
  end

  it "is invalid with 0 growbed spaces" do
    @material.growbed_spaces = 0
    @material.valid?
    expect(@material.errors[:growbed_spaces]).not_to eq([])
  end

  it "is invalid with a negative number of growbed spaces" do
    @material.growbed_spaces = -1
    @material.valid?
    expect(@material.errors[:growbed_spaces]).not_to eq([])
  end

  it "is valid with a positive number of storage spaces provided" do
    @material.storage_spaces_provided = 1
    expect(@material.valid?).to eq(true)
  end

  it "is invalid with 0 storage spaces provided" do
    @material.storage_spaces_provided = 0
    @material.valid?
    expect(@material.errors[:storage_spaces_provided]).not_to eq([])
  end

  it "is invalid with a negative number of storage spaces provided" do
    @material.storage_spaces_provided = -1
    @material.valid?
    expect(@material.errors[:storage_spaces_provided]).not_to eq([])
  end

  # behaviors
  it "is not craftable if it does not require materials" do
    expect(@material.craftable?).to eq(false)
  end

  it "is not carryable if it does not list the inventory space it requires" do
    expect(@material.carryable?).to eq(false)
  end

  it "is carryable if it takes up inventory space" do
    @material.inventory_spaces = 1
    expect(@material.carryable?).to eq(true)
  end

  it "returns marine growbed spaces required if it is Marine Flora" do
    @material.material_type = "Flora"
    @material.material_subtype = "Marine"
    @material.growbed_spaces = 1
    expect(@material.marine_growbed_spaces).to eq(1)
  end

  it "returns land growbed spaces required if it is Land Flora" do
    @material.material_type = "Flora"
    @material.material_subtype = "Land"
    @material.growbed_spaces = 1
    expect(@material.land_growbed_spaces).to eq(1)
  end

  it "returns containment spaces required if it is Fauna" do
    @material.material_type = "Fauna"
    @material.growbed_spaces = 1
    expect(@material.containment_spaces).to eq(1)
  end

  it "requires indoor space if it is an Interior Module" do
    @material.material_type = "Base Piece"
    @material.material_subtype = "Interior Module"
    expect(@material.requires_indoor_space?).to eq(true)
  end

  it "requires indoor space if it is an Interior Piece" do
    @material.material_type = "Base Piece"
    @material.material_subtype = "Interior Piece"
    expect(@material.requires_indoor_space?).to eq(true)
  end

  it "requires indoor space if it is a Miscellaneous Base Piece" do
    @material.material_type = "Base Piece"
    @material.material_subtype = "Miscellaneous"
    expect(@material.requires_indoor_space?).to eq(true)
  end

  it "does not require indoor space if it is not an Interior Piece, Interior Module or Miscellaneous Base Piece" do
    expect(@material.requires_indoor_space?).to eq(false)
  end

  it "does not return marine growbed spaces required if it is not Marine Flora" do
    @material.growbed_spaces = 1
    expect(@material.marine_growbed_spaces).to eq(nil)
  end

  it "does not return land growbed spaces required if it is not Land Flora" do
    @material.growbed_spaces = 1
    expect(@material.land_growbed_spaces).to eq(nil)
  end

  it "does not return containment spaces required if it is not Fauna" do
    @material.growbed_spaces = 1
    expect(@material.containment_spaces).to eq(nil)
  end

  context "with a blueprint" do
    before(:each) do
      @material2 = Material.create({
        material_name: "Test Material II",
        material_type: "Test Type"
      })

      @blueprint = Blueprint.create({
        material_produced: @material,
        material_required: @material2,
        number_required: 1
      })
    end

    # validations
    it "is invalid with a number produced if it can't be crafted" do
      @material2.number_produced = 1
      @material2.valid?
      expect(@material2.errors[:number_produced]).not_to eq([])
    end

    it "is invalid with a crafting location if it can't be crafted" do
      @material2.crafted_at = "Fabricated"
      @material2.valid?
      expect(@material2.errors[:crafted_at]).not_to eq([])
    end

    it "is invalid without a number produced if it can be crafted" do
      @material.valid?
      expect(@material.errors[:number_produced]).not_to eq([])
    end

    it "is valid if it can be crafted and produces a positive quantity" do
      @material.number_produced = 1
      @material.valid?
      expect(@material.errors[:number_produced]).to eq([])
    end

    it "is invalid if it can be crafted and produces 0" do
      @material.number_produced = 0
      @material.valid?
      expect(@material.errors[:number_produced]).not_to eq([])
    end

    it "is invalid if it can be crafted and produces a negative quantity" do
      @material.number_produced = -1
      @material.valid?
      expect(@material.errors[:number_produced]).not_to eq([])
    end

    it "is invalid if it can be crafted and does not have a crafting location" do
      @material.valid?
      expect(@material.errors[:crafted_at]).not_to eq([])
    end

    it "is valid if it has a crafting location and can be crafted" do
      @material.crafted_at = "Fabricated"
      @material.valid?
      expect(@material.errors[:crafted_at]).to eq([])
    end

    # associations
    it "returns blueprints where it is the material being produced" do
      expect(@material.blueprints).to include(@blueprint)
    end

    it "returns blueprints where it is the material being worked" do
      expect(@material2.blueprint_inclusions).to include(@blueprint)
    end

    it "returns the products used to produce it" do
      expect(@material.materials_required).to include(@material2)
    end

    it "returns the products it can be used to produce" do
      expect(@material2.materials_produced).to include(@material)
    end
  end

  context "with a byproduct" do
    before(:each) do
      @material2 = Material.create({
        material_name: "Test Material II",
        material_type: "Test Type"
      })

      @byproduct = Byproduct.create({
        material: @material,
        byproduct: @material2,
        number_produced: 1
      })
    end

    # associations
    it "returns instances of itself producing byproducts" do
      expect(@material.byproducts).to include(@byproduct)
    end

    it "returns instances where crafting an item produces it as a byproduct" do
      expect(@material2.byproducts_of).to include(@byproduct)
    end

    it "returns materials it produces as byproducts" do
      expect(@material.byproduct_materials).to include(@material2)
    end

    it "returns materials that produce it as a byproduct" do
      expect(@material2.byproduct_of_materials).to include(@material)
    end
  end
end
