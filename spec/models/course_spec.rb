require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:school) { FactoryBot.create(:school) }
  let(:course) { FactoryBot.create(:course, created_by: user, school:) }

  describe 'バリデーションチェック' do
    it '有効な授業であること' do
      expect(course).to be_valid
    end

    describe 'nameのバリデーション' do
      context 'nameが空の場合' do
        before { course.name = '' }
        it 'バリデーションが通らない' do
          expect(course).not_to be_valid
        end
      end

      context 'nameがnilの場合' do
        before { course.name = nil }
        it 'バリデーションが通らない' do
          expect(course).not_to be_valid
        end
      end
    end

    describe 'teacher_nameのバリデーション' do
      context 'teacher_nameが空の場合' do
        before { course.teacher_name = '' }
        it 'バリデーションが通らない' do
          expect(course).not_to be_valid
        end
      end

      context 'teacher_nameがnilの場合' do
        before { course.teacher_name = nil }
        it 'バリデーションが通らない' do
          expect(course).not_to be_valid
        end
      end
    end

    describe 'day_of_weekのバリデーション' do
      context 'day_of_weekが空の場合' do
        before { course.day_of_week = '' }
        it 'バリデーションが通らない' do
          expect(course).not_to be_valid
        end
      end

      context 'day_of_weekがnilの場合' do
        before { course.day_of_week = nil }
        it 'バリデーションが通らない' do
          expect(course).not_to be_valid
        end
      end
    end

    describe 'course_timeのバリデーション' do
      context 'course_timeが空の場合' do
        before { course.course_time = '' }
        it 'バリデーションが通らない' do
          expect(course).not_to be_valid
        end
      end

      context 'course_timeがnilの場合' do
        before { course.course_time = nil }
        it 'バリデーションが通らない' do
          expect(course).not_to be_valid
        end
      end
    end
  end

  describe 'アソシエーションテスト' do
    it 'ユーザーと関連付けられている' do
      expect(course.created_by).to eq(user)
    end

    it '学校と関連付けられている' do
      expect(course.school).to eq(school)
    end
  end
end
