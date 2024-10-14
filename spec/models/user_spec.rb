require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe 'バリデーションチェック' do
    it '有効なユーザーであること' do
      expect(user).to be_valid
    end

    describe 'uidのバリデーション' do
      context 'uidが空の場合' do
        before { user.uid = '' }
        it 'バリデーションが通らない' do
          expect(user).not_to be_valid
        end
      end

      context 'uidがnilの場合' do
        before { user.uid = nil }
        it 'バリデーションが通らない' do
          expect(user).not_to be_valid
        end
      end
    end

    describe 'nameのバリデーション' do
      context 'nameが空の場合' do
        before { user.name = '' }
        it 'バリデーションが通らない' do
          expect(user).not_to be_valid
        end
      end

      context 'nameがnilの場合' do
        before { user.name = nil }
        it 'バリデーションが通らない' do
          expect(user).not_to be_valid
        end
      end
    end

    describe 'user_typeのバリデーション' do
      context 'user_typeが空の場合' do
        before { user.user_type = '' }
        it 'バリデーションが通らない' do
          expect(user).not_to be_valid
        end
      end

      context 'user_typeがnilの場合' do
        before { user.user_type = nil }
        it 'バリデーションが通らない' do
          expect(user).not_to be_valid
        end
      end
    end
  end
end
