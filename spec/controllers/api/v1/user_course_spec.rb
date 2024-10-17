require 'rails_helper'

RSpec.describe Api::V1::UserCoursesController, type: :controller do
  let!(:teacher) { FactoryBot.create(:teacher) }
  let!(:student) { FactoryBot.create(:student) }
  let!(:school) { FactoryBot.create(:school) }
  let!(:course) { FactoryBot.create(:course, created_by: teacher, school:) }
  let!(:secondary_course) { FactoryBot.create(:secondary_course, created_by: teacher, school:) }
  let!(:user_course) { FactoryBot.create(:user_course, user: student, course:) }

  describe 'GET /api/v1/user_courses' do
    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      it '参加済み授業一覧の取得に成功する（ステータスコード200）' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context 'ユーザーが認証されていない場合' do
      it '参加済み授業一覧の取得に失敗する（ステータスコード401）' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/user_courses/:uuid' do
    before do
      @valid_params = { uuid: course.uuid }
      @valid_no_match_params = { uuid: 9999 }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      it '指定した参加済み授業の取得に成功する（ステータスコード200）' do
        get :show, params: @valid_params
        expect(response).to have_http_status(:success)
      end

      it '一致する参加済み授業がない場合、空のオブジェクトを返す（ステータスコード200）' do
        get :show, params: @valid_no_match_params
        expect(response).to have_http_status(:success)
        json_response = response.parsed_body
        expect(json_response).to be_nil
      end
    end

    context 'ユーザーが認証されていない場合' do
      it '指定した参加済み授業の取得に失敗する（ステータスコード401）' do
        get :show, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/user_courses' do
    before do
      @valid_params = { school_id: school.id, course_code: secondary_course.course_code }
      @invalid_params_nonexistent_course_code = { school_id: school.id, course_code: '4f9G7zX' }
      @invalid_params_already_enrolled = { school_id: school.id, course_code: course.course_code }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it '授業の参加に成功する（ステータスコード200）' do
          expect do
            post :create, params: @valid_params
          end.to change(UserCourse, :count).by(1)
          expect(response).to have_http_status(:success)
        end
      end

      context '無効なパラメータ' do
        it '一致する授業がない場合、参加に失敗する（ステータスコード404）' do
          post :create, params: @invalid_params_nonexistent_course_code
          expect(response).to have_http_status(:not_found)
        end

        it '既に参加済みの場合、参加に失敗する（ステータスコード409）' do
          post :create, params: @invalid_params_already_enrolled
          expect(response).to have_http_status(:conflict)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it '授業の参加に失敗する（ステータスコード401）' do
        post :create, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/user_courses/:uuid' do
    before do
      @valid_params = { uuid: course.uuid }
      @invalid_params_nonexistent_uuid = { uuid: 9999 }
      @invalid_params_not_enrolled = { uuid: course.uuid, scenario: 'teacher' }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it '授業の退出に成功する（ステータスコード200）' do
          expect do
            delete :destroy, params: @valid_params
          end.to change(UserCourse, :count).by(-1)
          expect(response).to have_http_status(:no_content)
        end
      end

      context '無効なパラメータ' do
        it '一致する授業がない場合、退出に失敗する（ステータスコード404）' do
          delete :destroy, params: @invalid_params_nonexistent_uuid
          expect(response).to have_http_status(:not_found)
        end

        it '授業の参加者ではない場合、退出に失敗する（ステータスコード403）' do
          delete :destroy, params: @invalid_params_not_enrolled
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it '授業の退出に失敗する（ステータスコード401）' do
        delete :destroy, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
