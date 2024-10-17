FactoryBot.define do
  factory :user_course do
    association :user
    association :course
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
