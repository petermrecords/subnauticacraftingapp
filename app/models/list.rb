class List < ApplicationRecord

	# associations
	belongs_to :user
	has_one :list_harvestable
	has_one :list_carryable

	# validations
	validates :user, presence: true
	validates :list_name, presence: true
	
end
