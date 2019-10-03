class List < ApplicationRecord

	include Listable

	# associations
	belongs_to :user
	has_one :list_harvestable, dependent: :destroy
	has_one :list_carryable, dependent: :destroy

	# validations
	validates :user, presence: true
	validates :list_name, presence: true

  # callbacks
  after_create :generate_versions

  def populate_carryable(list_materials)
    # add the carryables
    list_materials.select { |m| m.material.carryable? }.map do |list_material|
      if !list_carryable.list_materials.find_by(material: list_material.material)
        # add if its not there
        list_carryable.list_materials.build(material: list_material.material, number_desired: list_material.number_desired)
      else
        # add the quantity to the existing record if it is there
        list_carryable.list_materials.find_by(material: list_material.material).number_desired += list_material.number_desired
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

  def populate_harvestable(list_materials)
    list_materials.select { |m| m.material.harvestable? }.map do |list_material|
      if !list_harvestable.list_materials.find_by(material: list_material.material)
        list_harvestable.list_materials.build(material: list_material.material, number_desired: list_material.number_desired)
      else
        list_harvestable.list_materials.find_by(material: list_material.material).number_desired += list_material.number_desired
      end
    end
    bad = list_materials.select { |m| !m.material.harvestable? }
    if bad.empty?
      return list_harvestable
    else
      populate_harvestable(bad.map { |list_material| list_material.split_to_components }.flatten)
    end
  end

  private

  def generate_versions
    ListCarryable.create(list: self)
    ListHarvestable.create(list: self)
  end
end
