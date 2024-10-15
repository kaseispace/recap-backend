FactoryBot.define do
  factory :course do
    association :created_by, factory: :second_user
    association :school
    name { 'コンピュータサイエンス入門' }
    teacher_name { '佐藤次郎' }
    day_of_week { '水曜日' }
    course_time { '3限' }
    uuid { SecureRandom.uuid }
    course_code { SecureRandom.alphanumeric(7) }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }

    factory :secondary_course do
      name { 'ネットワークセキュリティ基礎' }
      teacher_name { '佐藤次郎' }
      day_of_week { '金曜日' }
      course_time { '1限' }
    end
  end
end
