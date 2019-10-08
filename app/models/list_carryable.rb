class ListCarryable < ApplicationRecord
	
  include Listable

	# associations
	belongs_to :list
	has_one :user, through: :list
  has_many :list_materials, as: :listable
  has_many :materials, through: :list_materials
  
	# validations
	validates :list, presence: true, uniqueness: true
  validate :carryable_materials_only

  private
  
  def carryable_materials_only
    if materials.select { |m| !m.carryable? }.any?
      errors.add(:materials, "can't include materials that are not carryable on the carryable version of a list")
    end
  end
end
