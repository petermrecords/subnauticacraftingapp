class ListCarryable < ApplicationRecord
	
	# associations
	belongs_to :list
	has_one :user, through: :list
  has_many :list_materials, as: :listable, dependent: :delete_all
  has_many :materials, through: :list_materials

	# validations
	validates :list, presence: true, uniqueness: true
end
