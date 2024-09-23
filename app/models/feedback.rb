class Feedback < ApplicationRecord
  belongs_to :user
  belongs_to :course
  belongs_to :course_date

  validates :comment, presence: true
end
