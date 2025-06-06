Rails.application.routes.draw do
  # アカウント編集後、任意のページに推移させるための記述
  devise_for :users, controllers: {
  sessions: "users/sessions",
  registrations: "users/registrations"
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :users, only: [ :show, :edit, :update ]

  resources :goals do
    resources :savings, only: [ :create ] # 貯金に関するルーティングをネスト
  end

  resources :boards do
    get :tags, on: :collection
    resources :comments, only: [ :create, :edit, :destroy, :update ], shallow: true
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  root "static_pages#top"
end
