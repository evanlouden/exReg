Rails.application.routes.draw do
  devise_for :accounts, controllers: { registrations: "registrations" }

  unauthenticated :account do
    root to: "welcome#index", as: "unauthenticated_root"
  end

  authenticated :account do
    root to: "dashboard#index", as: "authenticated_root"
  end

  resources :students do
    resources :inquiries
  end

  resources :contacts, only: [:new, :create]
  resources :dashboard, only: :index
  resources :admin do
    member do
      patch :change
      post :attendance
    end
  end
  resources :inquiries
  resources :contacts
  resources :prices
  resources :lessons do
    member do
      patch :attended
    end
  end
  resources :instruments
  resources :teachers
  resources :reasons
  resources :missed_lessons, only: :create
end
