FactoryBot.define do
  factory :prompt do
    association :course
    title { '第1回目の振り返り' }
    active { false }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }

    transient do
      questions_count { 3 }
    end

    after(:build) do |prompt, evaluator|
      prompt.prompt_questions = build_list(:prompt_question, evaluator.questions_count, prompt:)
    end

    factory :second_prompt do
      title { '第2回目の振り返り' }
      active { true }
    end

    factory :third_prompt do
      association :course, factory: :third_course
      title { 'アルゴリズムとデータ構造の振り返り' }
    end
  end

  factory :prompt_question do
    content { 'Sample Question' }
    prompt
  end
end
