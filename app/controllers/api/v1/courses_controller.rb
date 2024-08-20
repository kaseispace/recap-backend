module Api
  module V1
    class CoursesController < ApplicationController
      before_action :set_user, only: %i[index create update destroy]

      def index
        courses = Course.where(created_by_id: @user.id)
        render json: courses
      end

      # コースに参加しているユーザー一覧
      def joined_users
        course = Course.find(params[:id])
        users = course.users
        render json: users.as_json(only: [:name])
      end

      def create
        course = Course.new(course_params)
        course.created_by = @user
        if course.save
          render json: course
        elsif course.errors.details[:name].any? { |error| error[:error] == :taken }
          render json: { error: { messages: ['既に存在する授業名です。'] } }, status: :conflict
        else
          render json: { error: { messages: ['新規コースを登録できませんでした。'] } }, status: :unprocessable_entity
        end
      end

      def update
        course = Course.find(params[:id])
        if course.created_by_id == @user.id
          if course.update(course_params)
            render json: course
          elsif course.errors.details[:name].any? { |error| error[:error] == :taken }
            render json: { error: { messages: ['既に存在する授業名です。'] } }, status: :conflict
          else
            render json: { error: { messages: ['コースの更新に失敗しました。'] } }, status: :unprocessable_entity
          end
        else
          render json: { error: { messages: ['あなたはこのコースの作成者ではないため、編集できません。'] } }, status: :forbidden
        end
      end

      def destroy
        course = Course.find_by(id: params[:id])
        if course.created_by_id == @user.id
          if course.destroy
            head :no_content
          else
            render json: { error: { messages: ['コースの削除に失敗しました。'] } }, status: :unprocessable_entity
          end
        else
          render json: { error: { messages: ['あなたはこのコースの作成者ではないため、削除できません。'] } }, status: :forbidden
        end
      end

      private

      # ユーザーを探すメソッド
      def set_user
        @user = User.find_by(uid: @payload['user_id'])
      end

      def course_params
        params.require(:course).permit(:name, :teacher_name, :day_of_week, :course_time, :school_id)
      end

      def course_update_params
        params.require(:course).permit(:name, :teacher_name, :day_of_week, :course_time)
      end
    end
  end
end
