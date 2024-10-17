module Api
  module V1
    class UserCoursesController < ApplicationController
      before_action :payload_uid, only: %i[index show create destroy]
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
        return render json: { error: { messages: ['授業が存在しませんでした。'] } }, status: :not_found unless course

        user_course = UserCourse.find_or_initialize_by(user_id: @user.id, course_id: course.id)
        return render json: { error: { messages: ['既に参加済みです。'] } }, status: :conflict unless user_course.new_record?

        if user_course.save
          render json: course.as_json(only: %i[name teacher_name day_of_week course_time uuid])
        else
          render json: { error: { messages: ['授業に参加できませんでした。'] } }, status: :unprocessable_entity
        end
      end

      def destroy
        course = Course.find_by(uuid: params[:uuid])
        return render json: { error: { messages: ['授業が存在しませんでした。'] } }, status: :not_found unless course

        user_course = UserCourse.find_by(course_id: course.id, user_id: @user.id)
        unless user_course
          return render json: { error: { messages: ['あなたはこの授業の参加者ではないため、退出できません。'] } },
                        status: :forbidden
        end

        if user_course.destroy
          head :no_content
        else
          render json: { error: { messages: ['授業から退出できませんでした。'] } }, status: :unprocessable_entity
        end
      end

      private

      def payload_uid
        @payload['user_id']
      end

      def set_user
        @user = User.find_by(uid: payload_uid)
      end
    end
  end
end
