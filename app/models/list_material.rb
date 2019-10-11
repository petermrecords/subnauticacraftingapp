class ListMaterial < ApplicationRecord

  # associations
  belongs_to :listable, polymorphic: true
  belongs_to :material

  # validations
  validates :listable, presence: true
  validates :material, presence: true, uniqueness: { scope: :listable }
  validates :number_desired, numericality: { greater_than: 0 }

  # behaviors
  def to_s
    [number_desired.to_s, material.material_name].join(" ")
  end

  def split_to_components
    material.blueprints.map do |blueprint|
      ListMaterial.new(listable: listable, material: blueprint.material_required, number_desired: self.number_desired * blueprint.number_required)
    end
  end
end
