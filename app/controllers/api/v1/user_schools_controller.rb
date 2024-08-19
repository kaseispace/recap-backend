module Api
  module V1
    class UserSchoolsController < ApplicationController
      before_action :set_user, only: %i[index create]

      def index
        school = @user.schools.first
        render json:  { user: @user.as_json(only: %i[name user_type]), school: }
      end

      def create
        affiliation = Affiliation.new(affiliation_params.merge(user_id: @user.id))
        if affiliation.save
          user = affiliation.user
          school = affiliation.school
          render json: { user: user.as_json(only: %i[name user_type]), school: school.as_json(only: %i[id name]) }
        else
          render json: { error: { messages: ['所属を登録できませんでした。'] } }, status: :unprocessable_entity
        end
      end

      private

      def set_user
        @user = User.find_by(uid: @payload['user_id'])
      end

      def affiliation_params
        params.require(:affiliation).permit(:school_id)
      end
    end
  end
end
