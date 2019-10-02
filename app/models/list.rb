class List < ApplicationRecord

	include Listable

	# associations
	belongs_to :user
	has_one :list_harvestable, dependent: :destroy
	has_one :list_carryable, dependent: :destroy

	# validations
	validates :user, presence: true
	validates :list_name, presence: true

  # callbacks
  after_create :generate_versions

  private

  def generate_versions
    ListCarryable.create(list: self)
    ListHarvestable.create(list: self)
  end
	
end
