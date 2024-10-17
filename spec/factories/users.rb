FactoryBot.define do
  factory :user do
    uid { SecureRandom.alphanumeric(28) }
    name { '山田太郎' }
    user_type { 0 }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }

    factory :teacher do
      uid { 'mock_uid' }
      name { '佐藤次郎' }
      user_type { 1 }
    end

    factory :student do
      uid { 'mock_student_uid' }
      name { '田中一郎' }
      user_type { 0 }
    end
  end
end
