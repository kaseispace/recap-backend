FactoryBot.define do
  factory :announcement do
    association :course
    content { '来週水曜日のコンピュータサイエンス入門の授業は、オンラインで実施します。詳細はメールでお知らせします。' }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
