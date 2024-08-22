class Reflection < ApplicationRecord
  belongs_to :user
  belongs_to :course
  belongs_to :course_date

  validates :message, presence: true
  validates :message_type, presence: true
  validates :message_time, presence: true
end
