Rails.application.routes.draw do
  root  'rails/welcome#index'
  get "up" => "rails/health#show", as: :rails_health_check

  namespace "api" do
    namespace "v1" do
      resources :schools, only: [:index, :show]
      resources :users, only: [:create, :destroy], param: :uid
      resources :user_schools, only: [:index, :create]

      resources :courses, only: [:index, :show, :create, :update, :destroy], param: :uuid do
        member do
          get 'joined_users'
        end
      end

      resources :user_courses, only: [:index, :show, :create, :destroy], param: :uuid
      
      resources :announcements, only: [:create, :update, :destroy] do
        collection do
          get 'student_announcements'
          get 'teacher_announcements'
        end
      end
      
      resources :prompts, only: [:create, :update, :destroy] do
        collection do
          get 'teacher_prompts'
          get 'student_prompt'
        end
        member do
          patch 'activate_prompt'
        end
      end

      resources :course_dates, only: [:create, :update, :destroy] do
        collection do
          get 'teacher_course_dates'
          get 'student_course_dates'
        end
        member do
          patch 'reflection_status'
        end
      end

      resources :reflections, only: [:create, :update] do
        collection do
          get 'student_reflections'
          get 'all_student_reflection_status'
          get 'all_student_reflections'
          get 'check_reflection_on_date'
          get 'shared_reflections'
        end
      end

      resources :feedbacks,  only: [:create] do
        collection do
          get 'student_feedbacks'
        end
      end
    end
  end
end
