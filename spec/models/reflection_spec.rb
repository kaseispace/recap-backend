require 'rails_helper'

RSpec.describe Reflection, type: :model do
  let(:teacher) { FactoryBot.create(:teacher) }
  let(:student) { FactoryBot.create(:student) }
  let(:school) { FactoryBot.create(:school) }
  let(:course) { FactoryBot.create(:course, created_by: teacher, school:) }
  let(:user_course) { FactoryBot.create(:user_course, user: student, course:) }
  let(:course_date) { FactoryBot.create(:course_date, course:) }
  let(:reflection) { FactoryBot.create(:reflection, user: student, course:, course_date:) }

  describe 'バリデーションチェック' do
    it '有効な振り返りであること' do
      expect(reflection).to be_valid
    end

    describe 'messageのバリデーション' do
      context 'messageが空の場合' do
        before { reflection.message = '' }

        it 'バリデーションが通らない' do
          expect(reflection).not_to be_valid
        end
      end

      context 'messageがnilの場合' do
        before { reflection.message = nil }

        it 'バリデーションが通らない' do
          expect(reflection).not_to be_valid
        end
      end
    end

    describe 'message_typeのバリデーション' do
      context 'message_typeが空の場合' do
        before { reflection.message_type = '' }

        it 'バリデーションが通らない' do
          expect(reflection).not_to be_valid
        end
      end

      context 'message_typeがnilの場合' do
        before { reflection.message_type = nil }

        it 'バリデーションが通らない' do
          expect(reflection).not_to be_valid
        end
      end
    end

    describe 'message_timeのバリデーション' do
      context 'message_timeが空の場合' do
        before { reflection.message_time = '' }

        it 'バリデーションが通らない' do
          expect(reflection).not_to be_valid
        end
      end

      context 'message_timeがnilの場合' do
        before { reflection.message_time = nil }

        it 'バリデーションが通らない' do
          expect(reflection).not_to be_valid
        end
      end
    end
  end

  describe 'アソシエーションテスト' do
    it 'ユーザーと関連付けられている' do
      expect(reflection.user).to eq(student)
    end

    it '授業と関連付けられている' do
      expect(reflection.course).to eq(course)
    end

    it '授業日と関連付けられている' do
      expect(reflection.course_date).to eq(course_date)
    end
  end
end
