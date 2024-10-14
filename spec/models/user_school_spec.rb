require 'rails_helper'

RSpec.describe UserSchool, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:school) { FactoryBot.create(:school) }
  let(:user_school) { FactoryBot.create(:user_school, user:, school:) }

  describe 'バリデーションチェック' do
    it '有効なユーザーと学校であること' do
      expect(user_school).to be_valid
    end

    context '無効な場合' do
      it 'userが存在しない場合' do
        user_school.user = nil
        expect(user_school).not_to be_valid
      end

      it 'schoolが存在しない場合' do
        user_school.school = nil
        expect(user_school).not_to be_valid
      end
    end
  end

  describe 'アソシエーションテスト' do
    it 'ユーザーと関連付けられている' do
      expect(user_school.user).to eq(user)
    end

    it '学校と関連付けられている' do
      expect(user_school.school).to eq(school)
    end
  end
end
