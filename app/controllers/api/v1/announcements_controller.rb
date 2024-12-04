module Api
  module V1
    class AnnouncementsController < ApplicationController
      before_action :payload_uid, only: %i[teacher_announcements student_announcements create update destroy]
      before_action :set_user, only: %i[teacher_announcements student_announcements create update destroy]

      # 教員がお知らせを閲覧する用
      def teacher_announcements
        course = Course.find_by(created_by_id: @user.id, uuid: params[:uuid])
        unless course
          return render json: { error: { messages: ['あなたが作成したコースが見つかりませんでした。コースIDを確認してください。'] } },
                        status: :not_found
        end

        announcements = Announcement.where(course_id: course.id).order(created_at: :desc)
        render json: announcements
      end

      # 学生がお知らせを閲覧する用
      def student_announcements
        user_course = UserCourse.joins(:course).find_by(user_id: @user.id, 'courses.uuid' => params[:uuid])
        unless user_course
          return render json: { error: { messages: ['あなたが所属するコースが見つかりませんでした。コースIDを確認してください。'] } },
                        status: :not_found
        end

        announcements = Announcement.where(course_id: user_course.course_id).order(created_at: :desc)
        render json: announcements.as_json(only: %i[content created_at updated_at])
      end

      def create
        course = Course.find_by(uuid: params[:uuid], created_by_id: @user.id)
        return render json: { error: { messages: ['あなたは授業の作成者ではないのでお知らせを投稿できません。'] } }, status: :forbidden unless course

        announcement = Announcement.new(announcement_params)
        announcement.course_id = course.id

        if announcement.save
          render json: announcement
        else
          render json: { error: { messages: ['お知らせを登録できませんでした。'] } }, status: :unprocessable_entity
        end
      end

      def update
        announcement = Announcement.includes(:course).find_by(id: params[:id])
        return render json: { error: { messages: ['お知らせが存在しませんでした。'] } }, status: :not_found unless announcement

        unless announcement.course.created_by_id == @user.id
          return render json: { error: { messages: ['あなたは授業の作成者ではないのでお知らせを編集できません。'] } },
                        status: :forbidden
        end

        if announcement.update(announcement_params)
          render json: announcement
        else
          render json: { error: { messages: ['お知らせの更新に失敗しました。'] } }, status: :unprocessable_entity
        end
      end

      def destroy
        announcement = Announcement.includes(:course).find_by(id: params[:id])
        return render json: { error: { messages: ['お知らせが存在しませんでした。'] } }, status: :not_found unless announcement

        unless announcement.course.created_by_id == @user.id
          return render json: { error: { messages: ['あなたは授業の作成者ではないのでお知らせを削除できません。'] } },
                        status: :forbidden
        end

        if announcement.destroy
          head :no_content
        else
          render json: { error: { messages: ['お知らせの削除に失敗しました。'] } }, status: :unprocessable_entity
        end
      end

      private

      def payload_uid
        @payload['user_id']
      end

      def set_user
        @user = User.find_by(uid: payload_uid)
      end

      def announcement_params
        params.require(:announcement).permit(:content)
      end
    end
  end
end
