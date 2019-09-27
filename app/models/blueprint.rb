class Blueprint < ApplicationRecord
  
  # associations
  belongs_to :material_produced, class_name: "Material", foreign_key: :material_produced_id
  belongs_to :material_required, class_name: "Material", foreign_key: :material_required_id

  # validations
  validates :material_produced, presence: true
  validates :material_required, presence: true, uniqueness: { scope: :material_produced }
  validates :number_required, numericality: { greater_than: 0 }
end
