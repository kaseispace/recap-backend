require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }

  describe 'POST /api/v1/users' do
    include AuthenticationHelper

    before do
      @valid_params = { user: { name: '山田太郎', user_type: 0 } }
      @invalid_params = { user: { name: '', user_type: 0 } }
    end

    context '有効なパラメータ' do
      it 'ユーザーの作成に成功する（ステータスコード200）' do
        expect do
          post :create, params: @valid_params
        end.to change(User, :count).by(1)
        expect(response).to have_http_status(:success)
      end
    end

    context '無効なパラメータ' do
      it 'ユーザーの作成に失敗する（ステータスコード422）' do
        post :create, params: @invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /api/v1/users' do
    before do
      @valid_params = { uid: user.uid }
      @invalid_params = { uid: 'nonexistent_uid_9999' }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it 'ユーザーの削除に成功する（ステータスコード200）' do
          expect do
            delete :destroy, params: @valid_params
          end.to change(User, :count).by(-1)
          expect(response).to have_http_status(:no_content)
        end
      end

      context '無効なパラメータ' do
        it '一致するユーザーがない場合、削除に失敗する（ステータスコード404）' do
          delete :destroy, params: @invalid_params
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it 'ユーザーの削除に失敗する（ステータスコード401）' do
        delete :destroy, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
