FactoryBot.define do
  factory :user_school do
    association :user
    association :school

    factory :user_school_with_second_user do
      association :user, factory: :second_user
      association :school
    end
  end
end
