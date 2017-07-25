Rails.application.routes.draw do
  devise_for :users, only: []

  resources :sessions, only: :create
  resources :signups,  only: :create
  resources :forgotten_password_requests, only: :create
  resources :passwords, only: [:create, :update]

  get 'user_admin/search'
  post 'user_admin/refunds', to: 'user_admin#make_refund'
end
