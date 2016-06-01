Rails.application.routes.draw do
  devise_for :accounts, controllers: { registrations: "registrations" }

  root to: "welcome#index"

  resources :students, only: [:new, :create] do
    resources :inquiries, only: [:new, :create]
  end

  resources :contacts, only: [:new, :create]
  resources :dashboard, only: [:index]
end
