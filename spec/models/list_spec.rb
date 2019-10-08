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

  context "builds out the materials for its harvestable version" do
    before(:each) do
      @material = Material.create({
        material_name: "Non Harvestable Material",
        material_type: "Test Type"
      })
      @material2 = Material.create({
        material_name: "Harvestable Material",
        material_type: "Test Type"
      })
      @material3 = Material.create({
        material_name: "Harvestable Material II",
        material_type: "Test Type"
      })
      @material.blueprints.create({
        material_required: @material2,
        number_required: 1
      })
      @material.blueprints.create({
        material_required: @material3,
        number_required: 1
      })
      @list.list_materials.create({
        material: @material,
        number_desired: 2
      }) 
      @list.list_materials.create({
        material: @material2,
        number_desired: 1
      })
    end

    it "includes harvestable materials in its generic version in its harvestable version" do
      @list.populate_harvestable
      @list_harvestable = List.first.list_harvestable
      expect(@list_harvestable.materials).to include(@material2)
    end

    it "does not include non-harvestable materials in its generic version in its harvestable version" do
      @list.populate_harvestable
      @list_harvestable = List.first.list_harvestable
      expect(@list_harvestable.materials).not_to include(@material)
    end

    it "adds to the quantity of a material already in the harvestable version when one of the materials in the generic version is crafted from it" do
      @list.populate_harvestable
      @list_harvestable = List.first.list_harvestable
      expect(@list_harvestable.list_materials.find_by(material: @material2).number_desired).to eq(3)
    end

    it "adds new materials to the harvestable version when non-harvestable materials in the generic version are crafted from them" do
      @list.populate_harvestable
      @list_harvestable = List.first.list_harvestable
      expect(@list_harvestable.materials).to include(@material3)
    end

    context "uses recursion to find harvestable materials" do
      before(:each) do
        @material4 = Material.create({
          material_name: "Recursionite",
          material_type: "Test Type"
        })
        @material3.blueprints.create({
          material_required: @material4,
          number_required: 4
        })
      end

      it "goes 2 levels deep for havestable materials if it has to" do
        @list.populate_harvestable
        @list_harvestable = List.first.list_harvestable
        expect(@list_harvestable.materials).to include(@material4)
      end


      it "does not include craftable materials that are required for other craftable materials in the generic version" do
        @list.populate_harvestable
        @list_harvestable = List.first.list_harvestable
        expect(@list_harvestable.materials).not_to include(@material3)
      end

      it "goes 3 levels deep for harvestable materials if it has to" do
        @material5 = Material.create({
          material_name: "Double Recursonite",
          material_type: "Test Type"
        })
        @material4.blueprints.create({
          material_required: @material5,
          number_required: 1
        })
        @list.populate_harvestable
        @list_harvestable = List.first.list_harvestable
        expect(@list_harvestable.materials).to include(@material5)
      end
    end
  end

  context "builds out the materials for its carryable version" do
    before(:each) do
      @material = Material.create({
        material_name: "Non-carryable Material",
        material_type: "Test Type"
      })
      @material2 = Material.create({
        material_name: "Carryable Material",
        material_type: "Test Type",
        inventory_spaces: 1
      })
      @material3 = Material.create({
        material_name: "Carryable Material II",
        material_type: "Test Type",
        inventory_spaces: 2
      })
      @material.blueprints.create({
        material_required: @material2,
        number_required: 1
      })
      @material.blueprints.create({
        material_required: @material3,
        number_required: 1
      })
      @list.list_materials.create({
        material: @material,
        number_desired: 1
      })
      @list.list_materials.create({
        material: @material2,
        number_desired: 1
      })
    end

    it "includes carryable materials in the generic version in the carryable version" do
      @list.populate_carryable
      @list_carryable = List.first.list_carryable
      expect(@list_carryable.materials).to include(@material2)
    end

    it "does not include non-carryable materials in the generic version in the carryable version" do
      @list.populate_carryable
      @list_carryable = List.first.list_carryable
      expect(@list_carryable.materials).not_to include(@material)
    end

    it "adds to the quantity of a carryable material already in the carryable list if it is required for a non-carryable item in the generic version" do
      @list.populate_carryable
      @list_carryable = List.first.list_carryable
      expect(@list_carryable.list_materials.find_by(material: @material2).number_desired).to eq(2)
    end

    it "adds materials required to build non-carryable materials in the generic version to the carryable version" do
      @list.populate_carryable
      @list_carryable = List.first.list_carryable
      expect(@list_carryable.materials).to include(@material3)
    end

    it "does not add child materials to the carryable list if the parent material is carryable" do
      @material.inventory_spaces = 7
      @material.save
      @list.populate_carryable
      @list_carryable = List.first.list_carryable
      expect(@list_carryable.materials).not_to include(@material3)
    end

    it "does add materials that are crafted to the carryable list if they are carryable" do
      @material.inventory_spaces = 7
      @material.save
      @list.populate_carryable
      @list_carryable = List.first.list_carryable
      expect(@list_carryable.materials).to include(@material)
    end

    context "uses recursion to find carryable materials" do
      before(:each) do
        @material4 = Material.create({
          material_name: "Recursionite",
          material_type: "Test Type",
          inventory_spaces: 1
        })
        @material3.blueprints.create({
          material_required: @material4,
          number_required: 2
        })
        @material3.inventory_spaces = nil
        @material3.save
      end

      it "goes 2 levels deep for carryable materials if it has to" do
        @list.populate_carryable
        @list_carryable = List.first.list_carryable
        expect(@list_carryable.materials).to include(@material4)
      end

      it "does not include non-carryable materials that are required for other non-carryable materials" do
        @list.populate_carryable
        @list_carryable = List.first.list_carryable
        expect(@list_carryable.materials).not_to include(@material3)
      end

      it "goes 3 levels deep for carryable materials if it has to" do
        @material5 = Material.create({
          material_name: "Double Recursionite",
          material_type: "Test Type",
          inventory_spaces: 1
        })
        @material4.blueprints.create({
          material_required: @material5,
          number_required: 1
        })
        @material4.inventory_spaces = nil
        @material4.save
        @list.populate_carryable
        @list_carryable = List.first.list_carryable
        expect(@list_carryable.materials).to include(@material5)
      end
    end
  end
end
