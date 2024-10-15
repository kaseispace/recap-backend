require 'rails_helper'

RSpec.describe Api::V1::CoursesController, type: :controller do
  let!(:second_user) { FactoryBot.create(:second_user) }
  let!(:school) { FactoryBot.create(:school) }
  let!(:course) { FactoryBot.create(:course, created_by: second_user, school:) }
  let!(:secondary_course) { FactoryBot.create(:secondary_course, created_by: second_user, school:) }

  describe 'GET /api/v1/courses' do
    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      it '授業一覧の取得に成功する' do
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

  describe 'GET /api/v1/courses/:uuid' do
    before do
      @valid_params = { uuid: course.uuid }
      @invalid_params = { uuid: 9999 }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      it '指定した授業の取得に成功する' do
        get :show, params: @valid_params
        expect(response).to have_http_status(:success)
      end

      it '存在しない授業IDでリクエストすると空のオブジェクトを返す' do
        get :show, params: @invalid_params
        expect(response).to have_http_status(:success)
        json_response = response.parsed_body
        expect(json_response).to be_nil
      end
    end

    context 'ユーザーが認証されていない場合' do
      it 'ステータスコード401が返される' do
        get :show, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  # GET /api/v1/courses/:uuid/joined_users

  describe 'POST /api/v1/courses' do
    before do
      @valid_params = { course: { name: 'コンピュータサイエンス基礎', teacher_name: second_user.name, day_of_week: '火曜日',
                                  course_time: '4限', school_id: school.id } }
      @invalid_params_duplicate_name =  { course: { name: 'コンピュータサイエンス入門', teacher_name: second_user.name,
                                                    day_of_week: '火曜日', course_time: '4限', school_id: school.id } }
      @invalid_params_empty_name = { course: { name: '', teacher_name: second_user.name, day_of_week: '火曜日',
                                               course_time: '4限', school_id: school.id } }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it '授業の作成に成功する' do
          expect do
            post :create, params: @valid_params
          end.to change(Course, :count).by(1)
        end
      end

      context '無効なパラメータ' do
        it '同じ授業名での登録に失敗する（ステータスコード409）' do
          post :create, params: @invalid_params_duplicate_name
          expect(response).to have_http_status(:conflict)
        end

        it 'パラメータの欠如で登録に失敗する（ステータスコード422）' do
          post :create, params: @invalid_params_empty_name
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it 'ステータスコード401が返される' do
        get :create, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /api/v1/courses/:uuid' do
    before do
      @valid_params = { uuid: course.uuid, course: { name: 'コンピュータサイエンス応用' } }
      @invalid_params_nonexistent_uuid = { uuid: 9999, course: { name: 'コンピュータサイエンス応用' } }
      @invalid_params_duplicate_name = { uuid: course.uuid, course: { name: 'ネットワークセキュリティ基礎' } }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it '授業名の更新に成功する（ステータスコード200）' do
          patch :update, params: @valid_params
          expect(response).to have_http_status(:success)
          course.reload
          expect(course.name).to eq('コンピュータサイエンス応用')
        end
      end

      context '無効なパラメータ' do
        it '存在しない授業IDの更新に失敗する（ステータスコード404）' do
          patch :update, params: @invalid_params_nonexistent_uuid
          expect(response).to have_http_status(:not_found)
        end

        it '既に存在する授業名の更新に失敗する（ステータスコード409）' do
          patch :update, params: @invalid_params_duplicate_name
          expect(response).to have_http_status(:conflict)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it '授業の更新が認証なしで失敗する（ステータスコード401）' do
        patch :update, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/courses/:uuid' do
    before do
      @valid_params = { uuid: course.uuid }
      @invalid_params = { uuid: 9999 }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it '授業の削除に成功する（ステータスコード204）' do
          expect do
            delete :destroy, params: @valid_params
          end.to change(Course, :count).by(-1)
          expect(response).to have_http_status(:no_content)
        end
      end

      context '無効なパラメータ' do
        it '存在しない授業IDの削除に失敗する（ステータスコード404）' do
          delete :destroy, params: @invalid_params
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it '授業の削除が認証なしで失敗する（ステータスコード401）' do
        delete :destroy, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
