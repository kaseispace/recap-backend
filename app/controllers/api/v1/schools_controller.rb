module Api
  module V1
    class SchoolsController < ApplicationController
      skip_before_action :authenticate, only: %i[index show]

      # 学校一覧
      def index
        schools = School.select(:id, :name).order(:id)
        render json: schools
      end

      # 特定の学校
      def show
        schools = School.find(params[:id])
        render json: schools
      end
    end
  end
end
