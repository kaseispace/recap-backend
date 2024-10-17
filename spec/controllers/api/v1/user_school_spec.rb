require 'rails_helper'

RSpec.describe Api::V1::UserSchoolsController, type: :controller do
  let!(:teacher) { FactoryBot.create(:teacher) }
  let!(:school) { FactoryBot.create(:school) }
  let!(:user_school_with_teacher) { FactoryBot.create(:user_school_with_teacher, user: teacher, school:) }

  describe 'GET /api/v1/user_schools' do
    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper
      it 'ユーザーの所属する学校の取得に成功する（ステータスコード200）' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context 'ユーザーが認証されていない場合' do
      it 'ユーザーの所属する学校の取得に失敗する（ステータスコード401' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'CREATE /api/v1/user_schools' do
    before do
      @valid_params = { user_school: { school_id: school.id } }
      @invalid_params = { user_school: { school_id: 9999 } }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it 'ユーザーの所属作成に成功する（ステータスコード200）' do
          expect do
            post :create, params: @valid_params
          end.to change(UserSchool, :count).by(1)
          expect(response).to have_http_status(:success)
        end
      end

      context '無効なパラメータ' do
        it 'ユーザーの所属作成に失敗する（ステータスコード422）' do
          post :create, params: @invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it 'ユーザーの所属作成に失敗する（ステータスコード401）' do
        post :create, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
