class List < ApplicationRecord

	# associations
	belongs_to :user
	has_one :list_harvestable, dependent: :destroy
	has_one :list_carryable, dependent: :destroy
  has_many :list_materials, as: :listable, dependent: :delete_all
  has_many :materials, through: :list_materials

	# validations
	validates :user, presence: true
	validates :list_name, presence: true
	
end
