Rails.application.routes.draw do
  root  'rails/welcome#index'
  get "up" => "rails/health#show", as: :rails_health_check

  namespace "api" do
    namespace "v1" do
      resources :schools, only: [:index, :show]
      resources :users, only: [:create, :destroy], param: :uid
      resources :user_schools, only: [:index, :create]

      resources :courses, only: [:index, :create, :update, :destroy] do
        member do
          get 'joined_users'
        end
      end
    end
  end
end
