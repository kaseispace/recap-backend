class School < ApplicationRecord
  # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :user_schools
  # rubocop:enable Rails/HasManyOrHasOneDependent
  has_many :users, through: :user_school

  validates :name, presence: true
end
