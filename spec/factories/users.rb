FactoryBot.define do
  factory :user do
    uid { SecureRandom.alphanumeric(28) }
    name { '山田太郎' }
    user_type { 0 }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
