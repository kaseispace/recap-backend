FactoryBot.define do
  factory :feedback do
    association :user, factory: :student
    association :course
    association :course_date
    comment { 'この授業で学んだ内容を、次回の学習にどう活かすか考えてみてください。実際の応用例を探してみると、理解が深まりますよ！' }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
