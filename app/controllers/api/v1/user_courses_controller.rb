module Api
  module V1
    class UserCoursesController < ApplicationController
      before_action :set_user, only: %i[index show create destroy]

      def index
        courses = @user.courses
        render json: courses.as_json(only: %i[name teacher_name day_of_week course_time uuid])
      end

      def show
        course = @user.courses.find_by(uuid: params[:uuid])
        render json: course.as_json(only: %i[name teacher_name day_of_week course_time uuid])
      end

      def create
        course = Course.find_by(school_id: params[:school_id], course_code: params[:course_code])
        if course.nil?
          render json: { error: { messages: ['コースが見つかりませんでした。'] } }, status: :not_found
        else
          user_course = UserCourse.find_or_initialize_by(user_id: @user.id, course_id: course.id)
          if user_course.new_record?
            if user_course.save
              render json: course.as_json(only: %i[name teacher_name day_of_week course_time uuid])
            else
              render json: { error: { messages: ['コースに参加できませんでした。'] } }, status: :unprocessable_entity
            end
          else
            render json: { error: { messages: ['登録済みです。'] } }, status: :conflict
          end
        end
      end

      def destroy
        course = Course.find_by(uuid: params[:uuid])
        if course
          user_course = UserCourse.find_by(course_id: course.id, user_id: @user.id)
          if user_course
            if user_course.destroy
              head :no_content
            else
              render json: { error: { messages: ['コースから退出できませんでした。'] } }, status: :unprocessable_entity
            end
          else
            render json: { error: { messages: ['あなたはこのコースの参加者ではないため、退出できません。'] } }, status: :forbidden
          end
        else
          render json: { error: { messages: ['該当するコースが存在しませんでした'] } }, status: :not_found
        end
      end

      private

      def set_user
        @user = User.find_by(uid: @payload['user_id'])
      end
    end
  end
end
