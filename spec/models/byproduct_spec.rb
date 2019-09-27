require 'rails_helper'

RSpec.describe Byproduct, type: :model do
  before(:each) do
    @material = Material.create({
      material_name: "The Finished Good",
      material_type: "Test Type"
    })

    @material2 = Material.create({
      material_name: "The Byproduct",
      material_type: "Test Type"
    })

    @byproduct = Byproduct.create({
      material: @material,
      byproduct: @material2,
      number_produced: 1
    })
  end

  # validations
  it "is valid with a material, byproduct and number produced" do
    expect(@byproduct.valid?).to eq(true)
  end

  it "is not valid without a material producing the byproduct" do
    @byproduct.material = nil
    @byproduct.valid?
    expect(@byproduct.errors[:material]).not_to eq([])
  end

  it "is not valid without a byproduct being produced" do
    @byproduct.byproduct = nil
    @byproduct.valid?
    expect(@byproduct.errors[:byproduct]).not_to eq([])
  end

  it "is not valid without a number being produced" do
    @byproduct.number_produced = nil
    @byproduct.valid?
    expect(@byproduct.errors[:number_produced]).not_to eq([])
  end

  it "is not valid if it produces 0 byproduct" do
    @byproduct.number_produced = 0
    @byproduct.valid?
    expect(@byproduct.errors[:number_produced]).not_to eq([])
  end

  it "is not valid if it produces a negative quantity of byproduct" do
    @byproduct.number_produced = -1
    @byproduct.valid?
    expect(@byproduct.errors[:number_produced]).not_to eq([])
  end

  # associations
  it "returns the material producing the byproduct" do
    expect(@byproduct.material).to equal(@material)
  end

  it "returns the material being produced as byproduct" do
    expect(@byproduct.byproduct).to equal(@material2)
  end
end
