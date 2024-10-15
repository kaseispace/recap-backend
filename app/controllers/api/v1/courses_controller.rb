module Api
  module V1
    class CoursesController < ApplicationController
      before_action :payload_uid, only: %i[index show joined_users create update destroy]
      before_action :set_user, only: %i[index show joined_users create update destroy]

      def index
        courses = Course.where(created_by_id: @user.id)
        render json: courses
      end

      def show
        course = Course.find_by(uuid: params[:uuid], created_by_id: @user.id)
        render json: course
      end

      # コースに参加しているユーザー一覧
      def joined_users
        course = Course.find_by(uuid: params[:uuid], created_by_id: @user.id)
        return render json: { error: { messages: ['授業が存在しませんでした。'] } }, status: :not_found unless course

        joined_users = course.users
        render json: joined_users.as_json(only: %i[id name])
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
        course = Course.find_by(uuid: params[:uuid], created_by_id: @user.id)
        return render json: { error: { messages: ['授業が存在しませんでした。'] } }, status: :not_found unless course

        if course.update(course_params)
          render json: course
        elsif course.errors.details[:name].any? { |error| error[:error] == :taken }
          render json: { error: { messages: ['既に存在する授業名です。'] } }, status: :conflict
        else
          render json: { error: { messages: ['授業の更新に失敗しました。'] } }, status: :unprocessable_entity
        end
      end

      def destroy
        course = Course.find_by(uuid: params[:uuid], created_by_id: @user.id)
        return render json: { error: { messages: ['授業が存在しませんでした。'] } }, status: :not_found unless course

        if course.destroy
          head :no_content
        else
          render json: { error: { messages: ['授業の削除に失敗しました。'] } }, status: :unprocessable_entity
        end
      end

      private

      def payload_uid
        @payload['user_id']
      end

      def set_user
        @user = User.find_by(uid: payload_uid)
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
