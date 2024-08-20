class PromptQuestion < ApplicationRecord
  belongs_to :prompt

  validates :content, presence: true
end
