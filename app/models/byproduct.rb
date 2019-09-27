class Byproduct < ApplicationRecord

  # associations
  belongs_to :material
  belongs_to :byproduct, class_name: "Material", foreign_key: :byproduct_id

  # validations
  validates :material, presence: true
  validates :byproduct, presence: true, uniqueness: { scope: :material }
  validates :number_produced, numericality: { greater_than: 0 }
end
