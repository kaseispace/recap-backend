module Api
  module V1
    class ReflectionsController < ApplicationController
      before_action :set_user, only: %i[student_reflections create update]

      def student_reflections
        user_course = UserCourse.joins(:course).find_by(user_id: @user.id, 'courses.uuid' => params[:uuid])
        if user_course
          reflections = Reflection.where(user_id: @user.id,
                                         course_id: user_course.course_id).includes(:course_date)

          reflections_with_course_dates = reflections.group_by(&:course_date).map do |course_date, grouped_reflections|
            course_date.as_json(only: %i[id course_id course_number
                                         course_date]).merge(reflections: grouped_reflections)
          end
          render json: reflections_with_course_dates
        else
          render json: { error: { messages: ['あなたが所属するコースが見つかりませんでした。コースIDを確認してください。'] } }, status: :not_found
        end
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
          end
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

      def create
        user_course = UserCourse.joins(:course).find_by(user_id: @user.id, 'courses.uuid' => params[:uuid])
        return render json: { error: { messages: ['あなたの所属情報が見つかりませんでした。'] } }, status: :not_found unless user_course

        begin
          Reflection.transaction do
            new_reflections = Reflection.create!(reflection_params.map do |reflection|
                                                   reflection.merge(
                                                     user_id: @user.id,
                                                     course_id: user_course.course_id,
                                                     course_date_id: params[:course_date_id]
                                                   )
                                                 end)

            reflections_with_course_dates = new_reflections.group_by(&:course_date).map do |course_date, reflections|
              course_date.as_json(only: %i[course_id course_number
                                           course_date]).merge(reflections:)
            end
            render json: reflections_with_course_dates
          end
        rescue ActiveRecord::RecordInvalid => e
          render json: { error: { messages: ["データの保存に失敗しました： #{e.message}"] } }, status: :unprocessable_entity
        end
      end

      def update
        reflection = Reflection.find_by(id: params[:id], user_id: @user.id)
        return render json: { error: { messages: ['振り返りが存在しませんでした。'] } }, status: :not_found unless reflection

        if reflection.update(update_reflection_params)
          render json: reflection
        else
          render json: { error: { messages: reflection.errors.full_messages } }, status: :unprocessable_entity
        end
      end

      private

      # ユーザーを探すメソッド
      def set_user
        @user = User.find_by(uid: @payload['user_id'])
      end

      def reflection_params
        params.require(:course_date_id)
        params.require(:reflections).map do |reflection|
          reflection.permit(:message_type, :message, :message_time)
        end
      end

      def update_reflection_params
        params.permit(:message)
      end

      def reflection_history_params
        # reflectionキーのみを許可
        params.require(:reflection_history)
      end
    end
  end
end
