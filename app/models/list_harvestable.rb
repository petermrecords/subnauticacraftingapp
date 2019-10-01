class ListHarvestable < ApplicationRecord

  include Listable

	# associations
	belongs_to :list
	has_one :user, through: :list

	# validations
	validates :list, presence: true, uniqueness: true
  validate :harvestable_items_only

  private

  def harvestable_items_only
    if materials.select { |m| m.craftable? }.any?
      errors.add(:materials, "can't include craftable items on the harvestable version of a list")
    end
  end
end
