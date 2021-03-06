class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :lists, dependent: :destroy
  has_many :list_harvestables, through: :lists
  has_many :list_carryables, through: :lists

  validates :password, presence: true, length: { minimum: 6 }
end
