Rails.application.routes.draw do
  devise_for :accounts, controllers: { registrations: "registrations" }

  unauthenticated :account do
    root to: "welcome#index", as: "unauthenticated_root"
  end

  authenticated :account do
    root to: "dashboard#index", as: "authenticated_root"
  end

  resources :students, only: [:new, :create] do
    resources :inquiries, only: [:new, :create]
  end

  resources :contacts, only: [:new, :create]
  resources :dashboard, only: [:index]
end
