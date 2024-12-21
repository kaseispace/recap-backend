module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.new(user_params)
        user.uid = payload_uid
        if user.save
          render json: user
        else
          render json: { error: { messages: ['新規ユーザーを登録できませんでした。'] } }, status: :unprocessable_entity
        end
      end

      def destroy
        user = User.find_by(uid: params[:uid])
        return render json: { error: { messages: ['ユーザーが存在しませんでした。'] } }, status: :not_found unless user

        if user.destroy
          head :no_content
        else
          render json: { error: { messages: ['ユーザーを削除できませんでした。'] } }, status: :unprocessable_entity
        end
      end

      private

      def payload_uid
        @payload['user_id']
      end

      def user_params
        params.require(:user).permit(:name, :user_type)
      end
    end
  end
end
