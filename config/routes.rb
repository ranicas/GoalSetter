Rails.application.routes.draw do
  resources :users, only: [:create, :new]
  resources :goals
  resource :session, only: [:new, :create, :destroy]
end
