Rails.application.routes.draw do
  root 'home#index'

  resources :accounts
  resources :robots
  resources :robot_logs
  resources :informations
  resources :types
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
