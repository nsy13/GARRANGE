Rails.application.routes.draw do
  root to: 'home#index'
  resources :events
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
