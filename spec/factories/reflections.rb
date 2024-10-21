FactoryBot.define do
  factory :reflection do
    association :user, factory: :student
    association :course
    association :course_date
    message { 'こんにちは！' }
    message_type { 'bot' }
    message_time { '0' }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
