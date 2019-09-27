class Material < ApplicationRecord

  # associations
  has_many :blueprints, class_name: "Blueprint", foreign_key: :material_produced_id
  has_many :blueprint_inclusions, class_name: "Blueprint", foreign_key: :material_required_id
  has_many :materials_required, through: :blueprints, source: :material_required
  has_many :materials_produced, through: :blueprint_inclusions, source: :material_produced
  has_many :byproducts
  has_many :byproducts_of, class_name: "Byproduct", foreign_key: :byproduct_id
  has_many :byproduct_materials, through: :byproducts, source: :byproduct
  has_many :byproduct_of_materials, through: :byproducts_of, source: :material

  # validations
  validates :material_name, presence: true, uniqueness: true
  validates :material_type, presence: true
  validates :inventory_spaces, numericality: { greater_than: 0, allow_nil: true }
  validates :growbed_spaces, numericality: { greater_than: 0, allow_nil: true }
  validates :storage_spaces_provided, numericality: { greater_than: 0, allow_nil: true }
  validates :number_produced, numericality: { greater_than: 0, allow_nil: true }
  validate :crafted_item_has_location
  validate :crafted_item_produces_quantity

  # scopes
  scope :relevant_to_crafting, -> { where("inventory_spaces IS NOT NULL OR growbed_spaces IS NOT NULL OR material_type IN ('Base Piece','Placeable','Vehicle')") }

  # behaviors
  def carryable?
    !!inventory_spaces
  end

  def craftable?
    !materials_required.empty?
  end

  def marine_growbed_spaces
    growbed_spaces if material_type == "Flora" && material_subtype == "Marine"
  end

  def land_growbed_spaces
    growbed_spaces if material_type == "Flora" && material_subtype == "Land"
  end

  def containment_spaces
    growbed_spaces if material_type == "Fauna"
  end

  def requires_indoor_space?
    material_type = "Base Piece" && ["Interior Module","Interior Piece","Miscellaneous"].include?(material_subtype)
  end

  private

  def crafted_item_has_location
    if Blueprint.all.any? # skip it if they havent been seeded
      if craftable? && !crafted_at.present?
        errors.add(:crafted_at, "crafted item must be crafted someplace")
      elsif !craftable? && crafted_at.present?
        errors.add(:crafted_at, "non-craftable item cannot be crafted someplace")
      end
    end
  end

  def crafted_item_produces_quantity
    if Blueprint.all.any? # skip it if they havent been seeded
      if craftable? && !number_produced.present?
        errors.add(:number_produced, "crafted item must produce a quantity")
      elsif !craftable? && number_produced.present?
        errors.add(:number_produced, "non-craftable item cannot be produced")
      end
    end
  end
end
