require 'rails_helper'

RSpec.describe Feedback, type: :model do
  let(:teacher) { FactoryBot.create(:teacher) }
  let(:student) { FactoryBot.create(:student) }
  let(:school) { FactoryBot.create(:school) }
  let(:course) { FactoryBot.create(:course, created_by: teacher, school:) }
  let(:user_course) { FactoryBot.create(:user_course, user: student, course:) }
  let(:course_date) { FactoryBot.create(:course_date, course:) }
  let(:feedback) { FactoryBot.create(:feedback, user: student, course:, course_date:) }

  describe 'バリデーションチェック' do
    it '有効なフィードバックであること' do
      expect(feedback).to be_valid
    end

    describe 'commentのバリデーション' do
      context 'commentが空の場合' do
        before { feedback.comment = '' }

        it 'バリデーションが通らない' do
          expect(feedback).not_to be_valid
        end
      end

      context 'commentがnilの場合' do
        before { feedback.comment = nil }

        it 'バリデーションが通らない' do
          expect(feedback).not_to be_valid
        end
      end
    end
  end

  describe 'アソシエーションテスト' do
    it 'ユーザーと関連付けられている' do
      expect(feedback.user).to eq(student)
    end

    it '授業と関連付けられている' do
      expect(feedback.course).to eq(course)
    end

    it '授業日と関連付けられている' do
      expect(feedback.course_date).to eq(course_date)
    end
  end
end
