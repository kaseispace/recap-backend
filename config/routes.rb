Rails.application.routes.draw do
  root  'rails/welcome#index'
  get "up" => "rails/health#show", as: :rails_health_check

  namespace "api" do
    namespace "v1" do
      resources :schools, only: [:index, :show]
      resources :users, only: [:index, :show, :create, :destroy], param: :uid
      resources :user_schools, only: [:index, :show]
    end
  end
end
