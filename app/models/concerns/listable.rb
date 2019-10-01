module Listable
  extend ActiveSupport::Concern

  included do
    has_many :list_materials, as: :listable, dependent: :delete_all
    has_many :materials, through: :list_materials

    validates :list_materials, presence: true, on: :update
  end

  def how_many_of(material)
    m = list_materials.find_by(material: material) 
    m ? m.number_desired : 0
  end
end