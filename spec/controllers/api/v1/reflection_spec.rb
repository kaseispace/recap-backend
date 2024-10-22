require 'rails_helper'

RSpec.describe Api::V1::ReflectionsController, type: :controller do
  let!(:teacher) { FactoryBot.create(:teacher) }
  let!(:student) { FactoryBot.create(:student) }
  let!(:school) { FactoryBot.create(:school) }
  let!(:course) { FactoryBot.create(:course, created_by: teacher, school:) }
  let!(:second_course) { FactoryBot.create(:second_course, created_by: teacher, school:) }
  let!(:user_course) { FactoryBot.create(:user_course, user: student, course:) }
  let!(:second_user_course) { FactoryBot.create(:second_user_course, user: student, course: second_course) }
  let!(:course_date) { FactoryBot.create(:course_date, course:) }
  let!(:second_course_date) { FactoryBot.create(:second_course_date, course:) }
  let!(:third_course_date) { FactoryBot.create(:third_course_date, course: second_course) }
  let!(:reflection) { FactoryBot.create(:reflection, user: student, course:, course_date:) }

  describe 'GET /api/v1/reflections/student_reflections' do
    before do
      @valid_params = { uuid: course.uuid, scenario: 'student' }
      @valid_no_match_params = { uuid: second_course.uuid, scenario: 'student' }
      @invalid_params = { uuid: 9999, scenario: 'student' }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it '振り返り一覧の取得に成功する（ステータスコード200）' do
          get :student_reflections, params: @valid_params
          expect(response).to have_http_status(:success)
        end

        it '一致する振り返りがない場合、空の配列を返す（ステータスコード200）' do
          get :student_reflections, params: @valid_no_match_params
          expect(response).to have_http_status(:success)
          json_response = response.parsed_body
          expect(json_response).to eq([])
        end
      end

      context '無効なパラメータ' do
        it '無効な授業IDで振り返りの取得に失敗する（ステータスコード404）' do
          get :student_reflections, params: @invalid_params
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it '振り返り一覧の取得に失敗する（ステータスコード401）' do
        get :student_reflections, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/reflections/all_student_reflection_status' do
    before do
      @valid_params = { uuid: course.uuid }
      @invalid_params = { uuid: 9999 }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it '振り返り一覧の取得に成功する（ステータスコード200）' do
          get :all_student_reflection_status, params: @valid_params
          expect(response).to have_http_status(:success)
        end
      end

      context '無効なパラメータ' do
        it '無効な授業IDで振り返りの取得に失敗する（ステータスコード404）' do
          get :all_student_reflection_status, params: @invalid_params
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it '振り返り一覧の取得に失敗する（ステータスコード401）' do
        get :all_student_reflection_status, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/reflections/all_student_reflections' do
    before do
      @valid_params = { uuid: course.uuid }
      @invalid_params = { uuid: 9999 }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it '振り返り一覧の取得に成功する（ステータスコード200）' do
          get :all_student_reflections, params: @valid_params
          expect(response).to have_http_status(:success)
        end
      end

      context '無効なパラメータ' do
        it '無効な授業IDで振り返りの取得に失敗する（ステータスコード404）' do
          get :all_student_reflections, params: @invalid_params
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it '振り返り一覧の取得に失敗する（ステータスコード401）' do
        get :all_student_reflections, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/reflections/check_reflection_on_date' do
    before do
      @valid_params = { id: course.id, course_date_id: course_date.id }
      @valid_no_match_params = { id: second_course.id, course_date_id: third_course_date.id }
      @invalid_params = { id: 9999 }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it '授業日に登録済みの振り返りが存在する（ステータスコード200）' do
          get :check_reflection_on_date, params: @valid_params
          expect(response).to have_http_status(:success)
          json_response = response.parsed_body
          expect(json_response).to eq(true)
        end

        it '授業日に登録済みの振り返りが存在しない（ステータスコード200）' do
          get :check_reflection_on_date, params: @valid_no_match_params
          expect(response).to have_http_status(:success)
          json_response = response.parsed_body
          expect(json_response).to eq(false)
        end
      end

      context '無効なパラメータ' do
        it '無効な授業IDで振り返りの確認に失敗する（ステータスコード403）' do
          get :check_reflection_on_date, params: @invalid_params
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it '振り返りの確認に失敗する（ステータスコード401）' do
        get :check_reflection_on_date, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/reflections' do
    before do
      @valid_params = { uuid: course.uuid,
                        reflection: { course_date_id: second_course_date.id,
                                      reflections: [{ message_type: 'bot', message: 'こんにちは！', message_time: 0 },
                                                    { message_type: 'user', message: 'こんにちは', message_time: 2.3 }] },
                        scenario: 'student' }
      @invalid_params_empty_message = { uuid: course.uuid,
                                        reflection: { course_date_id: second_course_date.id,
                                                      reflections: [{ message_type: 'bot', message: '', message_time: 0 },
                                                                    { message_type: 'user', message: 'こんにちは',
                                                                      message_time: 2.3 }] },
                                        scenario: 'student' }
      @invalid_params_different_creator = { uuid: 9999,
                                            reflection: { course_date_id: second_course_date.id,
                                                          reflections: [{ message_type: 'bot', message: 'こんにちは！',
                                                                          message_time: 0 },
                                                                        { message_type: 'user', message: 'こんにちは',
                                                                          message_time: 2.3 }] },
                                            scenario: 'student' }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it '振り返りの作成に成功する（ステータスコード200）' do
          expect do
            post :create, params: @valid_params
          end.to change(Reflection, :count).by(2)
          expect(response).to have_http_status(:success)
        end
      end

      context '無効なパラメータ' do
        it 'メッセージが空の場合に振り返りの作成に失敗する（ステータスコード422）' do
          post :create, params: @invalid_params_empty_message
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it '授業の参加者以外による振り返りの作成が許可されない（ステータスコード404）' do
          post :create, params: @invalid_params_different_creator
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it '振り返りの作成に失敗する（ステータスコード401）' do
        post :create, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /api/v1/reflections/:id' do
    before do
      @valid_params = { id: reflection.id, message: 'こんばんは！', scenario: 'student' }
      @invalid_params_nonexistent_id = { id: 9999, message: 'こんばんは！', scenario: 'student' }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it '振り返りの編集に成功する（ステータスコード200）' do
          patch :update, params: @valid_params
          expect(response).to have_http_status(:success)
          reflection.reload
          expect(reflection.message).to eq('こんばんは！')
        end
      end

      context '無効なパラメータ' do
        it '一致する振り返りがない場合、更新に失敗する（ステータスコード404）' do
          patch :update, params: @invalid_params_nonexistent_id
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it '振り返りの更新に失敗する（ステータスコード401）' do
        patch :update, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
