class ListMaterial < ApplicationRecord

  # associations
  belongs_to :listable, polymorphic: true
  belongs_to :material

  # validations
  validates :listable, presence: true
  validates :material, presence: true, uniqueness: { scope: :listable }
  validates :number_desired, numericality: { greater_than: 0 }
end
