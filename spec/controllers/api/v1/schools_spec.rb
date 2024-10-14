require 'rails_helper'

RSpec.describe Api::V1::SchoolsController, type: :controller do
  include AuthenticationHelper
  let!(:school) { FactoryBot.create(:school) }

  describe 'GET /api/v1/schools' do
    it '学校一覧の取得に成功する' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/v1/schools/:id' do
    it '指定した学校の取得に成功する' do
      get :show, params: { id: school.id }
      expect(response).to have_http_status(:success)
    end

    it '指定した学校が存在しない' do
      get :show, params: { id: 9999 }
      expect(response).to have_http_status(:not_found)
    end
  end
end
