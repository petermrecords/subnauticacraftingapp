class ListCarryable < ApplicationRecord
	
	# associations
	belongs_to :list
	has_one :user, through: :list

	# validations
	validates :list, presence: true, uniqueness: true
end
