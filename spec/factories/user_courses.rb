FactoryBot.define do
  factory :user_course do
    association :user
    association :course
    created_at { Time.zone.now }
    updated_at { Time.zone.now }

    factory :second_user_course do
      association :course, factory: :second_course
    end
  end
end
