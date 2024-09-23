class User < ApplicationRecord
  has_many :user_schools, dependent: :destroy
  has_many :schools, through: :user_schools
  has_many :user_courses, dependent: :destroy
  has_many :courses, through: :user_courses
  has_many :created_courses, class_name: 'Course', foreign_key: 'created_by_id', dependent: :destroy
  has_many :reflections, dependent: :destroy
  has_many :feedbacks, dependent: :destroy

  validates :uid, presence: true, uniqueness: true
  validates :name, presence: true
  validates :user_type, presence: true
end
