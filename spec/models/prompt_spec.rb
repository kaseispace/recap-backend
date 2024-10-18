require 'rails_helper'

RSpec.describe Prompt, type: :model do
  let(:teacher) { FactoryBot.create(:teacher) }
  let(:school) { FactoryBot.create(:school) }
  let(:course) { FactoryBot.create(:course, created_by: teacher, school:) }
  let(:prompt) { FactoryBot.create(:prompt, course:) }

  describe 'バリデーションチェック' do
    it '有効なプロンプトであること' do
      expect(prompt).to be_valid
    end

    describe 'titleのバリデーション' do
      context 'titleが空の場合' do
        before { prompt.title = '' }

        it 'バリデーションが通らない' do
          expect(prompt).not_to be_valid
        end
      end

      context 'titleがnilの場合' do
        before { prompt.title = nil }

        it 'バリデーションが通らない' do
          expect(prompt).not_to be_valid
        end
      end
    end

    describe 'prompt_questionのバリデーション' do
      context 'prompt_questionが空の場合' do
        before { prompt.prompt_questions = [] }

        it 'バリデーションが通らない' do
          expect(prompt).not_to be_valid
        end
      end

      context 'prompt_questionのcontentが空の場合' do
        before { prompt.prompt_questions.first.content = '' }

        it 'バリデーションが通らない' do
          expect(prompt).not_to be_valid
        end
      end

      context 'prompt_questionのcontentがnilの場合' do
        before { prompt.prompt_questions.first.content = nil }

        it 'バリデーションが通らない' do
          expect(prompt).not_to be_valid
        end
      end
    end
  end

  describe 'アソシエーションテスト' do
    it '授業と関連付けられている' do
      expect(prompt.course).to eq(course)
    end

    it '質問が関連付けられている' do
      prompt.prompt_questions.each do |question|
        expect(question.prompt).to eq(prompt)
      end
    end
  end
end
