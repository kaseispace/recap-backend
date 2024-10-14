require 'rails_helper'

RSpec.describe School, type: :model do
  let(:school) { FactoryBot.create(:school) }

  describe 'バリデーションチェック' do
    it '有効な学校であること' do
      expect(school).to be_valid
    end

    describe 'nameのバリデーション' do
      context 'nameが空の場合' do
        before { school.name = '' }
        it 'バリデーションが通らない' do
          expect(school).not_to be_valid
        end
      end

      context 'nameがnilの場合' do
        before { school.name = nil }
        it 'バリデーションが通らない' do
          expect(school).not_to be_valid
        end
      end
    end
  end
end
