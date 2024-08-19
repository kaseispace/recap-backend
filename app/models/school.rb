class School < ApplicationRecord
  has_many :user_schools
  has_many :users, through: :user_school

  validates :name, presence: true
end
