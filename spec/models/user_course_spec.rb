require 'rails_helper'

RSpec.describe UserCourse, type: :model do
  let(:teacher) { FactoryBot.create(:teacher) }
  let(:student) { FactoryBot.create(:student) }
  let(:school) { FactoryBot.create(:school) }
  let(:course) { FactoryBot.create(:course, created_by: teacher, school:) }
  let(:user_course) { FactoryBot.create(:user_course, user: student, course:) }

  describe 'バリデーションチェック' do
    it '有効なユーザーと授業であること' do
      expect(user_course).to be_valid
    end

    context '無効な場合' do
      it 'userが存在しない場合' do
        user_course.user = nil
        expect(user_course).not_to be_valid
      end

      it 'courseが存在しない場合' do
        user_course.course = nil
        expect(user_course).not_to be_valid
      end
    end
  end

  describe 'アソシエーションテスト' do
    it 'ユーザーと関連付けられている' do
      expect(user_course.user).to eq(student)
    end

    it '授業と関連付けられている' do
      expect(user_course.course).to eq(course)
    end
  end
end
