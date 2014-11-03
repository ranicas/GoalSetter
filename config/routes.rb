Rails.application.routes.draw do
  resources :users, only: [:create, :new]
  resources :goals, only: [:index]
  resource :session, only: [:new, :create, :destroy]
end
