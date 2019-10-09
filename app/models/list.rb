class List < ApplicationRecord

	include Listable

	# associations
	belongs_to :user
	has_one :list_harvestable, dependent: :destroy
	has_one :list_carryable, dependent: :destroy
  has_many :list_materials, as: :listable, dependent: :destroy
  has_many :materials, through: :list_materials

	# validations
	validates :user, presence: true
	validates :list_name, presence: true

  # callbacks
  after_create :generate_versions

  # behavior
  
  def refresh_harvestable
    list_harvestable.list_materials.destroy_all
    populate_harvestable
  end

  def refresh_carryable
    list_carryable.list_materials.destroy_all
    populate_carryable
  end

  def update_with_versions(list_params)
    transaction do
      update(list_params)
      save
      if list_params[:list_materials]
        refresh_carryable
        refresh_harvestable
      end
    end
  end

  private

  def generate_versions
    ListCarryable.create(list: self)
    ListHarvestable.create(list: self)
  end

  def populate_carryable(list_materials = self.list_materials.to_a)
    # add the carryables
    list_materials.select { |m| m.material.carryable? }.map do |list_material|
      if !list_carryable.list_materials.find_by(material: list_material.material)
        # add if its not there
        list_carryable.list_materials.create(material: list_material.material, number_desired: list_material.number_desired)
      else
        # add the quantity to the existing record if it is there
        lm = list_carryable.list_materials.find_by(material: list_material.material)
        lm.number_desired += list_material.number_desired
        lm.save
      end
    end
    bad = list_materials.select { |m| !m.material.carryable? }
    if bad.empty?
      # everything's carryable now, proceed
      return list_carryable
    else
      # break the rest down one level and try it again
      populate_carryable(bad.map { |list_material| list_material.split_to_components }.flatten)
    end
  end

  def populate_harvestable(list_materials = self.list_materials.to_a)
    list_materials.select { |m| !m.material.craftable? }.map do |list_material|
      if !list_harvestable.list_materials.find_by(material: list_material.material)
        list_harvestable.list_materials.create(material: list_material.material, number_desired: list_material.number_desired)
      else
        lm = list_harvestable.list_materials.find_by(material: list_material.material)
        lm.number_desired += list_material.number_desired
        lm.save
      end
    end
    bad = list_materials.select { |m| m.material.craftable? }
    if bad.empty?
      return list_harvestable
    else
      populate_harvestable(bad.map { |list_material| list_material.split_to_components }.flatten)
    end
  end
end
