class Prompt < ApplicationRecord
  belongs_to :course
  has_many :prompt_questions, dependent: :destroy
  accepts_nested_attributes_for :prompt_questions, allow_destroy: true

  validates :title, presence: true
  validates_associated :prompt_questions
  validate :must_have_at_least_one_prompt_question

  def must_have_at_least_one_prompt_question
    return unless prompt_questions.empty?

    errors.add(:prompt_questions, '少なくとも1つの質問を含めてください。')
  end

  def self.activate(prompt_id)
    prompt = find(prompt_id)
    transaction do
      where(course_id: prompt.course_id, active: true).find_each do |record|
        record.update!(active: false)
      end
      prompt.update!(active: true)
    end
    true
  rescue StandardError
    false
  end

  def as_json(options = {})
    super(options.merge(include: :prompt_questions))
  end
end
