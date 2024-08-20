module Api
  module V1
    class UserSchoolsController < ApplicationController
      before_action :set_user, only: %i[index create]

      def index
        school = @user.schools.first
        render json:  { user: @user.as_json(only: %i[name user_type]), school: }
      end

      def create
        user_school = UserSchool.new(user_school_params.merge(user_id: @user.id))
        if user_school.save
          user = user_school.user
          school = user_school.school
          render json: { user: user.as_json(only: %i[name user_type]), school: school.as_json(only: %i[id name]) }
        else
          render json: { error: { messages: ['所属を登録できませんでした。'] } }, status: :unprocessable_entity
        end
      end

      private

      def set_user
        @user = User.find_by(uid: @payload['user_id'])
      end

      def user_school_params
        params.require(:user_school).permit(:school_id)
      end
    end
  end
end
