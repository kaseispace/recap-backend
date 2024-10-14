require 'rails_helper'

RSpec.describe Api::V1::UserSchoolsController, type: :controller do
  describe 'GET /api/v1/user_schools' do
    let!(:second_user) { FactoryBot.create(:second_user) }
    let!(:school) { FactoryBot.create(:school) }
    let!(:user_school_with_second_user) { FactoryBot.create(:user_school_with_second_user, user: second_user, school:) }

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper
      it 'ユーザーの所属する学校の取得に成功する' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context 'ユーザーが認証されていない場合' do
      it 'ステータスコード401が返される' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'CREATE /api/v1/user_schools' do
    let!(:second_user) { FactoryBot.create(:second_user) }
    let!(:school) { FactoryBot.create(:school) }

    before do
      @valid_params = { user_school: { school_id: school.id } }
      @invalid_params = { user_school: { school_id: 9999 } }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it 'ユーザーの所属を作成する' do
          expect do
            post :create, params: @valid_params
          end.to change(UserSchool, :count).by(1)
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

    context 'ユーザーが認証されていない場合' do
      it 'ステータスコード401が返される' do
        post :create, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
