class List < ApplicationRecord

	include Listable

	# associations
	belongs_to :user
	has_one :list_harvestable, dependent: :destroy
	has_one :list_carryable, dependent: :destroy

	# validations
	validates :user, presence: true
	validates :list_name, presence: true
	
end
