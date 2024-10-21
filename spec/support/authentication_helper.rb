module AuthenticationHelper
  extend ActiveSupport::Concern

  included do
    before do
      allow_any_instance_of(ApplicationController).to receive(:authenticate)
      allow_any_instance_of(Api::V1::UsersController).to receive(:payload_uid).and_return('mock_uid')
      allow_any_instance_of(Api::V1::UserSchoolsController).to receive(:payload_uid).and_return('mock_uid')
      allow_any_instance_of(Api::V1::CoursesController).to receive(:payload_uid).and_return('mock_uid')
      allow_any_instance_of(Api::V1::UserCoursesController).to receive(:payload_uid) do |controller|
        case controller.params[:scenario]
        when 'teacher'
          'mock_uid'
        else
          'mock_student_uid'
        end
      end
      allow_any_instance_of(Api::V1::AnnouncementsController).to receive(:payload_uid) do |controller|
        case controller.params[:scenario]
        when 'student'
          'mock_student_uid'
        else
          'mock_uid'
        end
      end
      allow_any_instance_of(Api::V1::PromptsController).to receive(:payload_uid) do |controller|
        case controller.params[:scenario]
        when 'student'
          'mock_student_uid'
        else
          'mock_uid'
        end
      end
      allow_any_instance_of(Api::V1::CourseDatesController).to receive(:payload_uid) do |controller|
        case controller.params[:scenario]
        when 'student'
          'mock_student_uid'
        else
          'mock_uid'
        end
      end
    end
  end
end
