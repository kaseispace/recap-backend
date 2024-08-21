module Api
  module V1
    class CourseDatesController < ApplicationController
      before_action :set_user,
                    only: %i[teacher_course_dates student_course_dates reflection_status create update destroy]

      # 振り返り履歴で表示するタイトル用
      def teacher_course_dates
        course = Course.find_by(created_by_id: @user.id, uuid: params[:uuid])
        if course
          render json: course.course_dates
        else
          render json: { error: { messages: ['授業日が登録されていません。'] } }, status: :not_found
        end
      end

      def student_course_dates
        user_course = UserCourse.joins(:course).find_by(user_id: @user.id, 'courses.uuid' => params[:uuid])
        if user_course
          course_dates = CourseDate.where(course_id: user_course.course_id)
          render json: course_dates
        else
          render json: { error: { messages: ['あなたが所属するコースが見つかりませんでした。コースIDを確認してください。'] } }, status: :not_found
        end
      end

      # 振り返りの有無
      def reflection_status
        course_date = CourseDate.find_by(id: params[:id])
        return render json: { error: { messages: ['授業日が存在しませんでした。'] } }, status: :not_found unless course_date

        course = Course.find_by(id: course_date.course_id, created_by_id: @user.id)
        return render json: { error: { messages: ['コースの作成者でないため、授業日を編集できません。'] } }, status: :forbidden unless course

        if course_date.update(is_reflection: !course_date.is_reflection)
          render json: course_date
        else
          render json: { error: { messages: course_date.errors.full_messages } }, status: :unprocessable_entity
        end
      end

      def create
        course = Course.find_by(uuid: params[:uuid], created_by_id: @user.id)
        unless course
          render json: { error: { messages: ['あなたは授業の作成者ではないので授業日を登録できません'] } }, status: :forbidden
          return
        end

        course_date = CourseDate.new(course_date_params.merge(course_id: course.id))
        if course_date.save
          render json: course_date
        elsif course_date.errors.details[:course_number].any? { |error| error[:error] == :taken } ||
              course_date.errors.details[:course_date].any? { |error| error[:error] == :taken }
          render json: { error: { messages: course_date.errors.messages } }, status: :conflict
        else
          render json: { error: { messages: course_date.errors.full_messages } }, status: :unprocessable_entity
        end
      end

      def update
        course_date = CourseDate.find_by(id: params[:id])
        return render json: { error: { messages: ['授業日が存在しませんでした。'] } }, status: :not_found unless course_date

        course = Course.find_by(id: course_date.course_id, created_by_id: @user.id)
        return render json: { error: { messages: ['コースの作成者でないため、授業日を編集できません。'] } }, status: :forbidden unless course

        if course_date.update(course_date_params)
          render json: course_date
        elsif course_date.errors.details[:course_number].any? { |error| error[:error] == :taken } ||
              course_date.errors.details[:course_date].any? { |error| error[:error] == :taken }
          render json: { error: { messages: course_date.errors.messages } }, status: :conflict
        else
          render json: { error: { messages: course_date.errors.full_messages } }, status: :unprocessable_entity
        end
      end

      def destroy
        course_date = CourseDate.find_by(id: params[:id])
        return render json: { error: { messages: ['授業日が存在しませんでした。'] } }, status: :not_found unless course_date

        course = Course.find_by(id: course_date.course_id, created_by_id: @user.id)
        return render json: { error: { messages: ['コースの作成者でないため、授業日を削除できません。'] } }, status: :forbidden unless course

        if course_date.destroy
          head :no_content
        else
          render json: { error: { messages: ['授業日の削除に失敗しました。'] } }, status: :unprocessable_entity
        end
      end

      private

      # ユーザーを探すメソッド
      def set_user
        @user = User.find_by(uid: @payload['user_id'])
      end

      def course_date_params
        params.require(:course_date).permit(:course_number, :course_date)
      end
    end
  end
end
