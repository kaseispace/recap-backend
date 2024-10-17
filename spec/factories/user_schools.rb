FactoryBot.define do
  factory :user_school do
    association :user
    association :school

    factory :user_school_with_teacher do
      association :user, factory: :teacher
      association :school
    end
  end
end
