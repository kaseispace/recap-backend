require 'rails_helper'

RSpec.describe Api::V1::CourseDatesController, type: :controller do
  let!(:teacher) { FactoryBot.create(:teacher) }
  let!(:second_teacher) { FactoryBot.create(:second_teacher) }
  let!(:student) { FactoryBot.create(:student) }
  let!(:school) { FactoryBot.create(:school) }
  let!(:user_course) { FactoryBot.create(:user_course, user: student, course:) }
  let!(:second_user_course) { FactoryBot.create(:second_user_course, user: student, course: second_course) }
  let!(:course) { FactoryBot.create(:course, created_by: teacher, school:) }
  let!(:second_course) { FactoryBot.create(:second_course, created_by: teacher, school:) }
  let!(:third_course) { FactoryBot.create(:third_course, created_by: second_teacher, school:) }
  let!(:course_date) { FactoryBot.create(:course_date, course:) }
  let!(:second_course_date) { FactoryBot.create(:second_course_date, course:) }

  describe 'GET /api/v1/course_dates/teacher_course_dates' do
    before do
      @valid_params = { uuid: course.uuid }
      @valid_no_match_params = { uuid: second_course.uuid }
      @invalid_params = { uuid: 9999 }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it '授業日一覧の取得に成功する（ステータスコード200）' do
          get :teacher_course_dates, params: @valid_params
          expect(response).to have_http_status(:success)
        end

        it '一致する授業日がない場合、空の配列を返す（ステータスコード200）' do
          get :teacher_course_dates, params: @valid_no_match_params
          expect(response).to have_http_status(:success)
          json_response = response.parsed_body
          expect(json_response).to eq([])
        end
      end

      context '無効なパラメータ' do
        it '無効な授業IDで授業日の取得に失敗する（ステータスコード404）' do
          get :teacher_course_dates, params: @invalid_params
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it '授業日一覧の取得に失敗する（ステータスコード401）' do
        get :teacher_course_dates, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/course_dates/student_course_dates' do
    before do
      @valid_params = { uuid: course.uuid, scenario: 'student' }
      @valid_no_match_params = { uuid: second_course.uuid, scenario: 'student' }
      @invalid_params = { uuid: 9999, scenario: 'student' }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it '授業日一覧の取得に成功する（ステータスコード200）' do
          get :student_course_dates, params: @valid_params
          expect(response).to have_http_status(:success)
        end

        it '一致する授業日がない場合、空の配列を返す（ステータスコード200）' do
          get :student_course_dates, params: @valid_no_match_params
          expect(response).to have_http_status(:success)
          json_response = response.parsed_body
          expect(json_response).to eq([])
        end
      end

      context '無効なパラメータ' do
        it '無効な授業IDで授業日の取得に失敗する（ステータスコード404）' do
          get :student_course_dates, params: @invalid_params
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it '授業日一覧の取得に失敗する（ステータスコード401）' do
        get :student_course_dates, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /api/v1/course_dates/:id/reflection_status' do
    before do
      @valid_params = { id: course_date.id }
      @invalid_params_nonexistent_id = { id: 9999 }
      @invalid_params_different_creator = { id: course_date.id, scenario: 'student' }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it '振り返りステータスの更新に成功する（ステータスコード200）' do
          patch :reflection_status, params: @valid_params
          expect(response).to have_http_status(:success)
        end
      end

      context '無効なパラメータ' do
        it '一致する授業日がない場合、更新に失敗する（ステータスコード404）' do
          patch :reflection_status, params: @invalid_params_nonexistent_id
          expect(response).to have_http_status(:not_found)
        end

        it '他のユーザーによる振り返りステータスの更新が許可されない（ステータスコード403）' do
          patch :reflection_status, params: @invalid_params_different_creator
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it '振り返りステータスの更新に失敗する（ステータスコード401）' do
        patch :reflection_status, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/course_dates' do
    before do
      @valid_params = { uuid: course.uuid, course_date: { course_number: '第3回', course_date: '2024/4/15' } }
      @invalid_params_different_creator = { uuid: third_course.uuid,
                                            course_date: { course_number: '第3回', course_date: '2024/4/15' } }
      @invalid_params_duplicate_course_number = { uuid: course.uuid,
                                                  course_date: { course_number: '第1回', course_date: '2024/4/15' } }
      @invalid_params_duplicate_course_date = { uuid: course.uuid,
                                                course_date: { course_number: '第3回', course_date: '2024/4/1' } }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it '授業日の作成に成功する（ステータスコード200）' do
          expect do
            post :create, params: @valid_params
          end.to change(CourseDate, :count).by(1)
          expect(response).to have_http_status(:success)
        end
      end

      context '無効なパラメータ' do
        it '無効な授業IDで授業日の作成に失敗する（ステータスコード403）' do
          post :create, params: @invalid_params_different_creator
          expect(response).to have_http_status(:forbidden)
        end

        it '同じ授業回での登録に失敗する（ステータスコード409）' do
          post :create, params: @invalid_params_duplicate_course_number
          expect(response).to have_http_status(:conflict)
        end

        it '同じ授業日での登録に失敗する（ステータスコード409）' do
          post :create, params: @invalid_params_duplicate_course_date
          expect(response).to have_http_status(:conflict)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it '授業日の作成に失敗する（ステータスコード401）' do
        post :create, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /api/v1/course_dates/:id' do
    before do
      @valid_params = { id: course_date.id, course_date: { course_date: '2024/4/2' } }
      @invalid_params_nonexistent_id = { id: 9999, course_date: { course_date: '2024/4/2' } }
      @invalid_params_different_creator = { id: course_date.id, course_date: { course_date: '2024/4/2' }, scenario: 'student' }
      @invalid_params_duplicate_course_date = { id: course_date.id, course_date: { course_date: '2024/4/8' } }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it '授業日の更新に成功する（ステータスコード200）' do
          patch :update, params: @valid_params
          expect(response).to have_http_status(:success)
          course_date.reload
          expect(course_date.course_date).to eq('2024/4/2')
        end
      end

      context '無効なパラメータ' do
        it '一致する授業日がない場合、更新に失敗する（ステータスコード404）' do
          patch :update, params: @invalid_params_nonexistent_id
          expect(response).to have_http_status(:not_found)
        end

        it '他のユーザーによる授業日の更新が許可されない（ステータスコード403）' do
          patch :update, params: @invalid_params_different_creator
          expect(response).to have_http_status(:forbidden)
        end

        it '既に存在する授業日の更新に失敗する（ステータスコード409）' do
          patch :update, params: @invalid_params_duplicate_course_date
          expect(response).to have_http_status(:conflict)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it '授業日の更新に失敗する（ステータスコード401）' do
        patch :update, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/course_dates/:id' do
    before do
      @valid_params = { id: course_date.id }
      @invalid_params_nonexistent_id = { id: 9999 }
      @invalid_params_different_creator = { id: course_date.id, scenario: 'student' }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it '授業日の削除に成功する（ステータスコード204）' do
          expect do
            delete :destroy, params: @valid_params
          end.to change(CourseDate, :count).by(-1)
          expect(response).to have_http_status(:no_content)
        end
      end

      context '無効なパラメータ' do
        it '一致する授業日がない場合、削除に失敗する（ステータスコード404）' do
          delete :destroy, params: @invalid_params_nonexistent_id
          expect(response).to have_http_status(:not_found)
        end

        it '他のユーザーによる授業日の削除が許可されない（ステータスコード403）' do
          delete :destroy, params: @invalid_params_different_creator
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it '授業日の削除に失敗する（ステータスコード401）' do
        delete :destroy, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
