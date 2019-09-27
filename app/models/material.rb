class Material < ApplicationRecord

  # associations
  has_many :materials_produced, class_name: "Blueprint", foreign_key: :material_produced_id
  has_many :materials_required, class_name: "Blueprint", foreign_key: :material_requried_id
  has_many :byproducts
  has_many :byproduct_of, class_name: "Byproduct", foreign_key: :byproduct_id

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

  def crafted?
    materials_required.empty?
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

  def requires_indoor_space
    material_type = "Base Piece" && ["Interior Module","Interior Piece","Miscellaneous"].include?(material_subtype)
  end

  private

  def crafted_item_has_location
    if !materials_required.empty? && !crafted_at.present?
      errors.add(:crafted_at, "crafted item must be crafted someplace")
    end
  end

  def crafted_item_produces_quantity
    if !materials_required.empty? && !number_produced.present?
      errors.add(:number_produced, "crafted item must produce a quantity")
    end
  end
end
