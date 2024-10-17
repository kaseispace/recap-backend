require 'rails_helper'

RSpec.describe Announcement, type: :model do
  let(:teacher) { FactoryBot.create(:teacher) }
  let(:school) { FactoryBot.create(:school) }
  let(:course) { FactoryBot.create(:course, created_by: teacher, school:) }
  let(:announcement) { FactoryBot.create(:announcement, course:) }

  describe 'バリデーションチェック' do
    it '有効なお知らせであること' do
      expect(announcement).to be_valid
    end

    describe 'contentのバリデーション' do
      context 'contentが空の場合' do
        before { announcement.content = '' }

        it 'バリデーションが通らない' do
          expect(announcement).not_to be_valid
        end
      end

      context 'contentがnilの場合' do
        before { announcement.content = nil }

        it 'バリデーションが通らない' do
          expect(announcement).not_to be_valid
        end
      end
    end
  end

  describe 'アソシエーションテスト' do
    it '授業と関連付けられている' do
      expect(announcement.course).to eq(course)
    end
  end
end
