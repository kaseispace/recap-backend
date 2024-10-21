require 'rails_helper'

RSpec.describe CourseDate, type: :model do
  let(:teacher) { FactoryBot.create(:teacher) }
  let(:school) { FactoryBot.create(:school) }
  let(:course) { FactoryBot.create(:course, created_by: teacher, school:) }
  let(:course_date) { FactoryBot.create(:course_date, course:) }

  describe 'バリデーションチェック' do
    it '有効な授業日であること' do
      expect(course_date).to be_valid
    end

    describe 'course_numberのバリデーション' do
      context 'course_numberが空の場合' do
        before { course_date.course_number = '' }

        it 'バリデーションが通らない' do
          expect(course_date).not_to be_valid
        end
      end

      context 'course_numberがnilの場合' do
        before { course_date.course_number = nil }

        it 'バリデーションが通らない' do
          expect(course_date).not_to be_valid
        end
      end
    end

    describe 'course_dateのバリデーション' do
      context 'course_dateが空の場合' do
        before { course_date.course_date = '' }

        it 'バリデーションが通らない' do
          expect(course_date).not_to be_valid
        end
      end

      context 'course_dateがnilの場合' do
        before { course_date.course_date = nil }

        it 'バリデーションが通らない' do
          expect(course_date).not_to be_valid
        end
      end
    end
  end

  describe 'アソシエーションテスト' do
    it '授業と関連付けられている' do
      expect(course_date.course).to eq(course)
    end
  end
end
