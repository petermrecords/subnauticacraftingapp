require 'rails_helper'

RSpec.describe Blueprint, type: :model do
  before(:each) do
    @material = Material.create({
      material_name: "The Finished Good",
      material_type: "Test Type"
    })

    @material2 = Material.create({
      material_name: "The Raw Material",
      material_type: "Test Type"
    })

    @blueprint = Blueprint.create({
      material_produced: @material,
      material_required: @material2,
      number_required: 1
    })
  end

  # validations
  it "is valid with a material produced, material required and a positive number required" do
    expect(@blueprint.valid?).to eq(true)
  end

  it "is invalid without a number of materials required" do
    @blueprint.number_required = nil
    @blueprint.valid?
    expect(@blueprint.errors[:number_required]).not_to eq([])
  end

  it "is invalid without a material produced" do
    @blueprint.material_produced = nil
    @blueprint.valid?
    expect(@blueprint.errors[:material_produced]).not_to eq([])
  end

  it "is invalid without a material required" do
    @blueprint.material_required = nil
    @blueprint.valid?
    expect(@blueprint.errors[:material_required]).not_to eq([])
  end

  it "is invalid if it requires 0 materials" do
    @blueprint.number_required = 0
    @blueprint.valid?
    expect(@blueprint.errors[:number_required]).not_to eq([])
  end

  it "is invalid if it requires a negative number of materials" do
    @blueprint.number_required = -rand(9999)
    @blueprint.valid?
    expect(@blueprint.errors[:number_required]).not_to eq([])
  end

  # associations
  it "returns the material it is meant to craft" do
    expect(@blueprint.material_produced).to equal(@material)
  end

  it "returns the material it requires" do
    expect(@blueprint.material_required).to equal(@material2)
  end
end
