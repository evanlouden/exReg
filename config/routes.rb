Rails.application.routes.draw do
  devise_for :accounts, controllers: { registrations: "registrations" }

  unauthenticated :account do
    root to: "welcome#index", as: "unauthenticated_root"
  end

  authenticated :account, ->(a) { a.admin && a.teacher } do
    root to: "admin#index", as: "adminteacher_root"
  end

  authenticated :account, ->(a) { a.admin } do
    root to: "admin#index", as: "admin_root"
  end

  authenticated :account, ->(a) { a.teacher } do
    root to: "teachers#show", as: "teacher_root"
  end

  authenticated :account, ->(a) { a.type == "Family" } do
    root to: "dashboard#index", as: "family_root"
  end

  resources :students do
    resources :inquiries
  end

  resources :dashboard, only: :index
  resources :admin do
    collection do
      get "search"
    end
    member do
      patch :change
    end
  end
  resources :inquiries
  resources :contacts do
    member do
      patch :change
    end
  end
  resources :prices
  resources :lessons do
    member do
      patch :attended
    end
  end
  resources :instruments
  resources :teachers
  resources :reasons
  resources :teacher_instruments
  resources :missed_lessons, only: :create
  resources :excused_absences, only: [:index, :create, :edit, :update]

  namespace :api do
    namespace :v1 do
      resources :calendar
      resources :teacher
    end
  end
end
