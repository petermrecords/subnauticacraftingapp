class ListHarvestable < ApplicationRecord

	# associations
	belongs_to :list
	has_one :user, through: :list
  has_many :list_materials, as: :listable, dependent: :delete_all
  has_many :materials, through: :list_materials

	# validations
	validates :list, presence: true, uniqueness: true
  validates :materials, presence: true
  validate :harvestable_items_only

  private

  def harvestable_items_only
    if materials.select { |m| m.craftable? }.any?
      errors.add(:materials, "can't include craftable items on the harvestable version of a list")
    end
  end
end
