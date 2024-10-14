require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'POST /api/v1/users' do
    include AuthenticationHelper

    before do
      @valid_params = { user: { name: '山田太郎', user_type: 0 } }
      @invalid_params = { user: { name: '', user_type: 0 } }
    end

    context '有効なパラメータ' do
      it '新しいユーザーを作成する' do
        expect do
          post :create, params: @valid_params
        end.to change(User, :count).by(1)
      end

      it 'ステータスコード200が返される' do
        post :create, params: @valid_params
        expect(response).to have_http_status(:success)
      end
    end

    context '無効なパラメータ' do
      it 'ステータスコード422が返される' do
        post :create, params: @invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /api/v1/users' do
    let!(:user) { FactoryBot.create(:user) }

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なUID' do
        it 'ユーザーを削除する' do
          expect do
            delete :destroy, params: { uid: user.uid }
          end.to change(User, :count).by(-1)
        end

        it 'ステータスコード204が返される' do
          delete :destroy, params: { uid: user.uid }
          expect(response).to have_http_status(:no_content)
        end
      end

      context '無効なUID' do
        it 'ステータスコード404が返される' do
          delete :destroy, params: { uid: 'nonexistent_uid_12345' }
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it 'ステータスコード401が返される' do
        delete :destroy, params: { uid: user.uid }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
