class Prompt < ApplicationRecord
  belongs_to :course
  has_many :prompt_questions, dependent: :destroy

  validates :title, presence: true

  def self.activate(prompt_id)
    prompt = find(prompt_id)
    transaction do
      where(course_id: prompt.course_id, active: true).find_each do |record|
        record.update!(active: false)
      end
      prompt.update!(active: true)
    end
  end
end
