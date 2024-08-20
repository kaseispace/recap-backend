class Course < ApplicationRecord
  before_create :set_uuid
  before_create :generate_unique_course_code

  belongs_to :created_by, class_name: 'User'
  belongs_to :school
  has_many :user_courses, dependent: :destroy
  has_many :users, through: :user_courses
  has_many :announcements, dependent: :destroy

  validates :name, presence: true
  validates :teacher_name, presence: true
  validates :day_of_week, presence: true
  validates :course_time, presence: true
  validates :name, uniqueness: { scope: :created_by_id }

  private

  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def generate_unique_course_code
    loop do
      self.course_code = SecureRandom.alphanumeric(7)
      break unless Course.exists?(school_id:, course_code:)
    end
  end
end
