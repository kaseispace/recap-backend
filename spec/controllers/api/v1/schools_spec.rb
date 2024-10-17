require 'rails_helper'

RSpec.describe Api::V1::SchoolsController, type: :controller do
  include AuthenticationHelper
  let!(:school) { FactoryBot.create(:school) }

  describe 'GET /api/v1/schools' do
    it '学校一覧の取得に成功する（ステータスコード200）' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/v1/schools/:id' do
    before do
      @valid_params = { id: school.id }
      @invalid_params = { id: 9999 }
    end

    it '指定した学校の取得に成功する（ステータスコード200）' do
      get :show, params: @valid_params
      expect(response).to have_http_status(:success)
    end

    it '一致する学校がない場合、空のオブジェクトを返す（ステータスコード200）' do
      get :show, params: @invalid_params
      expect(response).to have_http_status(:success)
      json_response = response.parsed_body
      expect(json_response).to be_nil
    end
  end
end
