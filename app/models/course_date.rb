class CourseDate < ApplicationRecord
  belongs_to :course

  validates :course_number, presence: true, uniqueness: { scope: :course_id, message: '既に存在する授業回です。' }
  validates :course_date, presence: true, uniqueness: { scope: :course_id, message: '既に存在する授業日です。' }
end
