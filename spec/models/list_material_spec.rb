require 'rails_helper'

RSpec.describe ListMaterial, type: :model do
  before(:each) do
    @user = User.create(email: "abcd1234@emails.com", password: "abcd1234")
    @list = List.create(user: @user, list_name: "Test List")
    @material = Material.create({
      material_name: "Test Material I",
      material_type: "Test Type"
    })
    @list_material = ListMaterial.create(listable: @list, material: @material, number_desired: rand(9999) + 1)
  end

  it "is valid with a related list, related material, and number desired" do
    expect(@list_material.valid?).to eq(true)
  end

  it "is invalid without a number desired" do
    @list_material.number_desired = nil
    @list_material.valid?
    expect(@list_material.errors[:number_desired]).not_to eq([])
  end

  it "is invalid with 0 desired" do
    @list_material.number_desired = 0
    @list_material.valid?
    expect(@list_material.errors[:number_desired]).not_to eq([])
  end

  it "is invalid with a negative number desired" do
    @list_material.number_desired = -(rand(9999) + 1)
    @list_material.valid?
    expect(@list_material.errors[:number_desired]).not_to eq([])
  end

  it "is invalid without a related material" do
    @list_material.material = nil
    @list_material.valid?
    expect(@list_material.errors[:material]).not_to eq([])
  end

  it "is invalid without a a related list" do
    @list_material.listable = nil
    @list_material.valid?
    expect(@list_material.errors[:listable]).not_to eq([])
  end

  it "cannot add 2 of the same material to a single list" do
    @list_material2 = ListMaterial.new(listable: @list, material: @material, number_desired: 7)
    @list_material2.valid?
    expect(@list_material2.errors[:material]).not_to eq([])
  end

  it "can add a material to more than one list" do
    @list2 = List.create(user: @user, list_name: "Test List II")
    @list_material2 = ListMaterial.new(listable: @list2, material: @material)
    expect(@list_material2.valid?).to eq(true)
  end
end
