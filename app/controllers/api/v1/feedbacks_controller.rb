module Api
  module V1
    class FeedbacksController < ApplicationController
      before_action :payload_uid, only: %i[student_feedbacks create]
      before_action :set_user, only: %i[student_feedbacks create]

      def student_feedbacks
        user_course = UserCourse.joins(:course).find_by(user_id: @user.id, 'courses.uuid' => params[:uuid])
        unless user_course
          return render json: { error: { messages: ['あなたが所属するコースが見つかりませんでした。コースIDを確認してください。'] } },
                        status: :not_found
        end

        feedbacks = Feedback.where(user_id: @user.id, course_id: user_course.course_id)
        render json: feedbacks
      end

      def create
        user_course = UserCourse.joins(:course).find_by(user_id: @user.id,
                                                        'courses.uuid' => feedback_params[:uuid])
        return render json: { error: { messages: ['あなたの所属情報が見つかりませんでした。'] } }, status: :not_found unless user_course

        # 改行する
        formatted_reflection_history = feedback_params[:reflection_history].join("\n")

        begin
          service = OpenaiFeedbackGeneratorService.new(formatted_reflection_history)
          generated_text = service.call
          # フィードバックが返されたら、保存する処理をこの後に行う
          feedback = Feedback.new(user_id: @user.id, course_id: user_course.course_id,
                                  course_date_id: feedback_params[:course_date_id], comment: generated_text)
          if feedback.save
            render json: feedback
          else
            render json: { error: { messages: ['フィードバックを保存できませんでした。'] } }, status: :unprocessable_entity
          end
        rescue OpenaiFeedbackGeneratorService::OpenAIError => e
          render json: { error: e.message }, status: e.status
        end
      end

      private

      def payload_uid
        @payload['user_id']
      end

      def set_user
        @user = User.find_by(uid: payload_uid)
      end

      def feedback_params
        params.require(:feedback).permit(:uuid, :course_date_id, reflection_history: [])
      end
    end
  end
end
