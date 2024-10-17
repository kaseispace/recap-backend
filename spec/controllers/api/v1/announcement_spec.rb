require 'rails_helper'

RSpec.describe Api::V1::AnnouncementsController, type: :controller do
  let!(:teacher) { FactoryBot.create(:teacher) }
  let!(:student) { FactoryBot.create(:student) }
  let!(:school) { FactoryBot.create(:school) }
  let!(:course) { FactoryBot.create(:course, created_by: teacher, school:) }
  let!(:secondary_course) { FactoryBot.create(:secondary_course, created_by: teacher, school:) }
  let!(:announcement) { FactoryBot.create(:announcement, course:) }

  describe 'GET /api/v1/announcements/teacher_announcements' do
    before do
      @valid_params = { uuid: course.uuid }
      @valid_no_match_params = { uuid: secondary_course.uuid }
      @invalid_params = { uuid: 9999 }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it 'お知らせ一覧の取得に成功する（ステータスコード200）' do
          get :teacher_announcements, params: @valid_params
          expect(response).to have_http_status(:success)
        end

        it '一致するお知らせがない場合、空の配列を返す（ステータスコード200）' do
          get :teacher_announcements, params: @valid_no_match_params
          expect(response).to have_http_status(:success)
          json_response = response.parsed_body
          expect(json_response).to eq([])
        end
      end

      context '無効なパラメータ' do
        it '無効な授業IDでお知らせの取得に失敗する（ステータスコード404）' do
          get :teacher_announcements, params: @invalid_params
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it 'お知らせ一覧の取得に失敗する（ステータスコード401）' do
        get :teacher_announcements, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  #   GET /api/v1/announcements/student_announcements

  describe 'POST /api/v1/announcements' do
    before do
      @valid_params = { uuid: course.uuid, announcement: { content: '来週の授業は休校です。' } }
      @invalid_params = { uuid: 9999, announcement: { content: '来週の授業は休校です。' } }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it 'お知らせの作成に成功する（ステータスコード200）' do
          expect do
            post :create, params: @valid_params
          end.to change(Announcement, :count).by(1)
          expect(response).to have_http_status(:success)
        end
      end

      context '無効なパラメータ' do
        it '無効な授業IDでお知らせの作成に失敗する（ステータスコード403）' do
          post :create, params: @invalid_params
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it 'お知らせの作成に失敗する（ステータスコード401）' do
        post :create, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /api/v1/announcements/:id' do
    before do
      @valid_params = { id: announcement.id, announcement: { content: 'オンラインで実施する予定でしたが、休校とします。' } }
      @invalid_params_nonexistent_id = { id: 9999, announcement: { content: 'オンラインで実施する予定でしたが、休校とします。' } }
      @invalid_params_different_creator = { id: announcement.id, announcement: { content: 'オンラインで実施する予定でしたが、休校とします。' },
                                            scenario: 'student' }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it 'お知らせの更新に成功する（ステータスコード200）' do
          patch :update, params: @valid_params
          expect(response).to have_http_status(:success)
          announcement.reload
          expect(announcement.content).to eq('オンラインで実施する予定でしたが、休校とします。')
        end
      end

      context '無効なパラメータ' do
        it '一致するお知らせがない場合、更新に失敗する（ステータスコード404）' do
          patch :update, params: @invalid_params_nonexistent_id
          expect(response).to have_http_status(:not_found)
        end

        it '他のユーザーによるお知らせの編集が許可されない（ステータスコード403）' do
          patch :update, params: @invalid_params_different_creator
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it 'お知らせの更新に失敗する（ステータスコード401）' do
        patch :update, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/announcements/:id' do
    before do
      @valid_params = { id: announcement.id }
      @invalid_params_nonexistent_id = { id: 9999 }
      @invalid_params_different_creator = { id: announcement.id, scenario: 'student' }
    end

    context 'ユーザーが認証されている場合' do
      include AuthenticationHelper

      context '有効なパラメータ' do
        it 'お知らせの削除に成功する（ステータスコード200）' do
          expect do
            delete :destroy, params: @valid_params
          end.to change(Announcement, :count).by(-1)
          expect(response).to have_http_status(:no_content)
        end
      end

      context '無効なパラメータ' do
        it '一致するお知らせがない場合、削除に失敗する（ステータスコード404）' do
          delete :destroy, params: @invalid_params_nonexistent_id
          expect(response).to have_http_status(:not_found)
        end

        it '他のユーザーによるお知らせの削除が許可されない（ステータスコード403）' do
          delete :destroy, params: @invalid_params_different_creator
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'ユーザーが認証されていない場合' do
      it 'お知らせの削除に失敗する（ステータスコード401）' do
        delete :destroy, params: @valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
