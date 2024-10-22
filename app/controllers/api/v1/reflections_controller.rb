module Api
  module V1
    class ReflectionsController < ApplicationController
      before_action :payload_uid, only: %i[student_reflections check_reflection_on_date create update]
      before_action :set_user, only: %i[student_reflections check_reflection_on_date create update]

      def student_reflections
        user_course = UserCourse.joins(:course).find_by(user_id: @user.id, 'courses.uuid' => params[:uuid])
        unless user_course
          return render json: { error: { messages: ['あなたが所属するコースが見つかりませんでした。コースIDを確認してください。'] } },
                        status: :not_found
        end

        reflections = Reflection.where(user_id: @user.id,
                                       course_id: user_course.course_id).includes(:course_date).order(:created_at)

        reflections_with_course_dates = reflections.group_by(&:course_date).map do |course_date, grouped_reflections|
          course_date.as_json(only: %i[id course_id course_number
                                       course_date]).merge(reflections: grouped_reflections)
        end
        render json: reflections_with_course_dates
      end

      def all_student_reflection_status
        course = Course.includes(course_dates: :reflections, users: :reflections).find_by(uuid: params[:uuid])
        unless course
          return render json: { error: { messages: ['あなたが所属するコースが見つかりませんでした。コースIDを確認してください。'] } },
                        status: :not_found
        end

        users = course.users
        course_dates = course.course_dates

        reflections_by_date = course_dates.map do |course_date|
          users_reflections = users.map do |user|
            reflections = user.reflections.select do |reflection|
              reflection.course_date_id == course_date.id
            end
            user_hash = user.slice('id', 'name')
            user_hash['reflections'] = reflections.map(&:attributes).presence || []
            user_hash
          end
          course_date_hash = course_date.attributes
          course_date_hash['users_reflections'] = users_reflections
          { 'course_date' => course_date_hash }
        end
        render json: reflections_by_date
      rescue StandardError
        render json: { error: { messages: ['予期しないエラーが発生しました。'] } }, status: :unprocessable_entity
      end

      def all_student_reflections
        course = Course.includes(users: { reflections: :course_date }).find_by(uuid: params[:uuid])
        unless course
          return render json: { error: { messages: ['あなたが所属するコースが見つかりませんでした。コースIDを確認してください。'] } },
                        status: :not_found
        end

        users = course.users

        reflection_dates_by_user = users.map do |user|
          user_reflections = user.reflections.select do |reflection|
            reflection.course_date.course_id == course.id
          end.sort_by(&:created_at)

          user_reflection_dates = user_reflections.group_by(&:course_date).map do |date, reflections|
            course_date_hash = date.attributes
            course_date_hash['reflections'] = reflections
            course_date_hash
          end
          user_hash = { 'user_id' => user.id, 'name' => user.name,
                        'user_reflections' => user_reflection_dates }
          user_hash
        end
        render json: reflection_dates_by_user
      rescue StandardError
        render json: { error: { messages: ['予期しないエラーが発生しました。'] } }, status: :unprocessable_entity
      end

      def check_reflection_on_date
        course = Course.find_by(id: check_reflection_params[:id], created_by_id: @user.id)
        unless course
          return render json: { error: { messages: ['あなたが作成したコースが見つかりませんでした。コースIDを確認してください。'] } },
                        status: :forbidden
        end

        reflection = Reflection.find_by(course_id: course.id,
                                        course_date_id: check_reflection_params[:course_date_id])
        render json: reflection.present?
      end

      def create
        user_course = UserCourse.joins(:course).find_by(user_id: @user.id, 'courses.uuid' => params[:uuid])
        return render json: { error: { messages: ['あなたの所属情報が見つかりませんでした。'] } }, status: :not_found unless user_course

        begin
          Reflection.transaction do
            new_reflections = reflection_params[:reflections].map do |reflection|
              Reflection.create!(
                reflection.merge(
                  user_id: @user.id,
                  course_id: user_course.course_id,
                  course_date_id: reflection_params[:course_date_id]
                )
              )
            end

            reflections_with_course_dates = new_reflections.group_by(&:course_date).map do |course_date, reflections|
              course_date.as_json(only: %i[course_id course_number course_date]).merge(reflections:)
            end

            render json: reflections_with_course_dates
          end
        rescue ActiveRecord::RecordInvalid
          render json: { error: { messages: ['振り返りを登録できませんでした。'] } }, status: :unprocessable_entity
        end
      end

      def update
        reflection = Reflection.find_by(id: params[:id], user_id: @user.id)
        return render json: { error: { messages: ['振り返りが存在しませんでした。'] } }, status: :not_found unless reflection

        if reflection.update(update_reflection_params)
          render json: reflection
        else
          render json: { error: { messages: ['振り返りの更新に失敗しました。'] } }, status: :unprocessable_entity
        end
      end

      private

      def payload_uid
        @payload['user_id']
      end

      def set_user
        @user = User.find_by(uid: payload_uid)
      end

      def check_reflection_params
        params.permit(:id, :course_date_id)
      end

      def reflection_params
        params.require(:reflection).permit(:course_date_id, reflections: %i[message_type message message_time])
      end

      def update_reflection_params
        params.permit(:message)
      end
    end
  end
end
