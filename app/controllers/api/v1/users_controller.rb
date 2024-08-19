module Api
  module V1
    class UsersController < ApplicationController
      # skip_before_action :authenticate, only: [:index]

      # 新規ユーザー登録
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
        if user.destroy
          render json: { messages: ["#{payload_uid}のユーザーを削除しました。"] }
        else
          render json: { error: { messages: ['ユーザーを削除できませんでした。'] } }, status: :unprocessable_entity
        end
      end

      private

      # payloadのuidを返すメソッド
      def payload_uid
        @payload['user_id']
      end

      def user_params
        params.require(:user).permit(:name, :user_type)
      end
    end
  end
end
