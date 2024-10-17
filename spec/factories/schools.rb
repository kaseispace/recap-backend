FactoryBot.define do
  factory :school do
    name { '星月大学' }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
