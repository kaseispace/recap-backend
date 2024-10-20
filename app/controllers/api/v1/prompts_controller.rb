module Api
  module V1
    class PromptsController < ApplicationController
      before_action :payload_uid, only: %i[teacher_prompts student_prompt activate_prompt create update destroy]
      before_action :set_user,
                    only: %i[teacher_prompts student_prompt activate_prompt create update destroy]

      # 授業内で作成されたプロンプトを取得
      def teacher_prompts
        course = Course.find_by(created_by_id: @user.id, uuid: params[:uuid])
        unless course
          return render json: { error: { messages: ['あなたが作成したコースが見つかりませんでした。コースIDを確認してください。'] } },
                        status: :not_found
        end

        prompts = Prompt.includes(:prompt_questions).where(course_id: course.id)
        render json: prompts, include: :prompt_questions
      end

      # 学生に公開するプロンプトを取得
      def student_prompt
        user_course = UserCourse.joins(:course).find_by(user_id: @user.id, 'courses.uuid' => params[:uuid])
        unless user_course
          return render json: { error: { messages: ['あなたが所属するコースが見つかりませんでした。コースIDを確認してください。'] } },
                        status: :not_found
        end

        prompt = Prompt.includes(:prompt_questions).find_by(course_id: user_course.course_id, active: true)
        if prompt
          contents = prompt.prompt_questions.map(&:content)
          render json: contents
        else
          render json: []
        end
      end

      # プロンプトをactiveにする
      def activate_prompt
        prompt = Prompt.includes(:course).find_by(id: params[:id])
        return render json: { error: { messages: ['プロンプトが存在しませんでした。'] } }, status: :not_found unless prompt

        unless prompt.course.created_by_id == @user.id
          return render json: { error: { messages: ['あなたは授業の作成者ではないのでプロンプトの有効化はできません。'] } },
                        status: :forbidden
        end

        if Prompt.activate(params[:id])
          head :no_content
        else
          render json: { error: { messages: ['プロンプトの有効化に失敗しました。'] } }, status: :unprocessable_entity
        end
      end

      def create
        course = Course.find_by(uuid: params[:uuid], created_by_id: @user.id)
        return render json: { error: { messages: ['あなたは授業の作成者ではないのでプロンプトの作成はできません。'] } }, status: :forbidden unless course

        prompt = Prompt.new(prompt_params)
        prompt.course = course

        if prompt.save
          render json: prompt
        else
          render json: { error: { messages: ['プロンプトを登録できませんでした。'] } }, status: :unprocessable_entity
        end
      end

      def update
        prompt = Prompt.includes(:course).find_by(id: params[:id])
        return render json: { error: { messages: ['プロンプトが存在しませんでした。'] } }, status: :not_found unless prompt

        unless prompt.course.created_by_id == @user.id
          return render json: { error: { messages: ['あなたは授業の作成者ではないのでプロンプトを編集できません。'] } },
                        status: :forbidden
        end

        begin
          Prompt.transaction do
            raise ActiveRecord::Rollback unless prompt.update(prompt_params)

            params[:prompt][:prompt_questions_attributes]&.each do |question_params|
              if !question_params[:id] && !prompt.prompt_questions.exists?(content: question_params[:content])
                prompt.prompt_questions.create!(content: question_params[:content])
              end
            end
          end

          render json: prompt
        rescue ActiveRecord::RecordInvalid => e
          render json: { error: { messages: ['プロンプトの編集に失敗しました。', e.message] } }, status: :unprocessable_entity
        end
      end

      def destroy
        prompt = Prompt.includes(:course).find_by(id: params[:id])
        return render json: { error: { messages: ['プロンプトが存在しませんでした。'] } }, status: :not_found unless prompt

        unless prompt.course.created_by_id == @user.id
          return render json: { error: { messages: ['あなたは授業の作成者ではないのでプロンプトを削除できません。'] } },
                        status: :forbidden
        end

        if prompt.destroy
          head :no_content
        else
          render json: { error: { messages: ['プロンプトの削除に失敗しました。'] } }, status: :unprocessable_entity
        end
      end

      private

      def payload_uid
        @payload['user_id']
      end

      def set_user
        @user = User.find_by(uid: payload_uid)
      end

      def prompt_params
        params.require(:prompt).permit(:title, prompt_questions_attributes: %i[id content _destroy])
      end
    end
  end
end
