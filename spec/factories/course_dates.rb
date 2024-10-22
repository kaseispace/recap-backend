FactoryBot.define do
  factory :course_date do
    association :course
    course_number { '第1回' }
    course_date { '2024/4/1' }
    is_reflection { true }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }

    factory :second_course_date do
      course_number { '第2回' }
      course_date { '2024/4/8' }
    end

    factory :third_course_date do
      association :course, factory: :second_course
      course_number { '第1回' }
      course_date { '2024/4/3' }
    end
  end
end
