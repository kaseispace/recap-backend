require 'rails_helper'

RSpec.describe Api::V1::FeedbacksController, type: :controller do
  let!(:teacher) { FactoryBot.create(:teacher) }
  let!(:student) { FactoryBot.create(:student) }
  let!(:school) { FactoryBot.create(:school) }
  let!(:course) { FactoryBot.create(:course, created_by: teacher, school:) }
  let!(:second_course) { FactoryBot.create(:second_course, created_by: teacher, school:) }
  let!(:user_course) { FactoryBot.create(:user_course, user: student, course:) }
  let!(:second_user_course) { FactoryBot.create(:second_user_course, user: student, course: second_course) }
  let!(:course_date) { FactoryBot.create(:course_date, course:) }
  let!(:third_course_date) { FactoryBot.create(:third_course_date, course: second_course) }
  let!(:feedback) { FactoryBot.create(:feedback, user: student, course:, course_date:) }

  describe 'GET /api/v1/feedbacks/student_feedbacks' do
    before do
      @valid_params = { uuid: course.uuid }
      @valid_no_match_params = { uuid: second_course.uuid }
      @invalid_params = { uuid: 9999 }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it 'フィードバック一覧の取得に成功する（ステータスコード200）' do
          get :student_feedbacks, params: @valid_params
          expect(response).to have_http_status(:success)
        end

        it '一致するフィードバックがない場合、空の配列を返す（ステータスコード200）' do
          get :student_feedbacks, params: @valid_no_match_params
          expect(response).to have_http_status(:success)
          json_response = response.parsed_body
          expect(json_response).to eq([])
        end
      end

      context '無効なパラメータ' do
        it '無効な授業IDでフィードバックの取得に失敗する（ステータスコード404）' do
          get :student_feedbacks, params: @invalid_params
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it 'フィードバック一覧の取得に失敗する（ステータスコード401）' do
        get :student_feedbacks, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/feedbacks' do
    before do
      @valid_params = { feedback: { uuid: course.uuid, course_date_id: course_date.id,
                                    reflection_history: ['今日の授業で学んだ新しいプログラミング言語について、どこが一番難しかったですか？',
                                                         'やはり、オブジェクト指向の考え方を理解するのが一番難しかったです。
                                                          でも、クラスとオブジェクトの関係を例を使って説明してもらえたので、少しずつ理解が深まってきました。'] } }
      @invalid_params = { feedback: { uuid: 9999, course_date_id: course_date.id,
                                      reflection_history: ['今日の授業で学んだ新しいプログラミング言語について、どこが一番難しかったですか？',
                                                           'やはり、オブジェクト指向の考え方を理解するのが一番難しかったです。
                                                           でも、クラスとオブジェクトの関係を例を使って説明してもらえたので、少しずつ理解が深まってきました。'] } }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it 'フィードバックの作成に成功する（ステータスコード200）' do
          expect do
            post :create, params: @valid_params
          end.to change(Feedback, :count).by(1)
          expect(response).to have_http_status(:success)
        end
      end

      context '無効なパラメータ' do
        it '授業の参加者以外によるフィードバックの作成が許可されない（ステータスコード404）' do
          post :create, params: @invalid_params
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it 'フィードバックの作成に失敗する（ステータスコード401）' do
        post :create, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
