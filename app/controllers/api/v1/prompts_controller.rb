module Api
  module V1
    class PromptsController < ApplicationController
      before_action :set_user,
                    only: %i[teacher_prompts student_prompt activate_prompt create update destroy]

      # 授業内で作成されたプロンプトを取得
      def teacher_prompts
        course = Course.find_by(created_by_id: @user.id, uuid: params[:uuid])
        if course
          prompts = Prompt.includes(:prompt_questions).where(course_id: course.id)
          render json: prompts, include: :prompt_questions
        else
          render json: { error: { messages: ['あなたが作成した振り返りが見つかりませんでした。コースIDを確認してください。'] } },
                 status: :not_found
        end
      end

      # 学生に公開するプロンプトを取得
      def student_prompt
        user_course = UserCourse.joins(:course).find_by(user_id: @user.id, 'courses.uuid' => params[:uuid])
        if user_course
          prompt = Prompt.includes(:prompt_questions).find_by(course_id: user_course.course_id, active: true)
          if prompt
            contents = prompt.prompt_questions.map(&:content)
            render json: contents
          else
            render json: []
          end
        else
          render json: { error: { messages: ['あなたが所属するコースが見つかりませんでした。コースIDを確認してください。'] } }, status: :not_found
        end
      end

      # プロンプトをactiveにする
      def activate_prompt
        prompt = Prompt.find_by(id: params[:id])
        if prompt
          if Course.find_by(id: prompt.course_id, created_by_id: @user.id)
            Prompt.activate(params[:id])
            head :no_content
          else
            render json: { error: { messages: ['あなたは授業の作成者ではないので振り返りを編集できません'] } }, status: :forbidden
          end
        else
          render json: { error: { messages: ['振り返りが存在しませんでした。'] } }, status: :not_found
        end
      end

      def create
        course = Course.find_by(uuid: params[:uuid], created_by_id: @user.id)
        if course
          prompt = Prompt.new(prompt_params)
          prompt.course_id = course.id
          if prompt.save
            params[:contents].each do |content|
              PromptQuestion.create(prompt_id: prompt.id, content:)
            end
            prompt_questions = prompt.prompt_questions
            render json: prompt.attributes.merge(prompt_questions:)
          else
            render json: { error: { messages: ['振り返りを登録できませんでした。'] } }, status: :unprocessable_entity
          end
        else
          render json: { error: { messages: ['あなたは授業の作成者ではないので振り返りを投稿できません'] } }, status: :forbidden
        end
      end

      def update
        prompt = Prompt.find_by(id: params[:id])
        if prompt
          if Course.find_by(id: prompt.course_id, created_by_id: @user.id)
            ActiveRecord::Base.transaction do
              if prompt.update(prompt_params)
                prompt.prompt_questions.destroy_all
                params[:contents].each do |content|
                  PromptQuestion.create(prompt_id: prompt.id, content:)
                end
                prompt.reload
                prompt_questions = prompt.prompt_questions.includes(:prompt)
                render json: prompt.attributes.merge(prompt_questions:)
              else
                render json: { error: { messages: ['振り返りの更新に失敗しました。'] } }, status: :unprocessable_entity
              end
            end
          else
            render json: { error: { messages: ['あなたは授業の作成者ではないので振り返りを編集できません'] } }, status: :forbidden
          end
        else
          render json: { error: { messages: ['振り返りが存在しませんでした。'] } }, status: :not_found
        end
      end

      def destroy
        prompt = Prompt.find_by(id: params[:id])
        if prompt
          course = Course.find_by(id: prompt.course_id, created_by_id: @user.id)
          if course
            if prompt.destroy
              head :no_content
            else
              render json: { error: { messages: ['振り返りの削除に失敗しました。'] } }, status: :unprocessable_entity
            end
          else
            render json: { error: { messages: ['コースの作成者でないため、振り返りを削除できません。'] } }, status: :forbidden
          end
        else
          render json: { error: { messages: ['振り返りが存在しませんでした。'] } }, status: :not_found
        end
      end

      private

      # ユーザーを探すメソッド
      def set_user
        @user = User.find_by(uid: @payload['user_id'])
      end

      def prompt_params
        params.require(:prompt).permit(:title)
      end
    end
  end
end
