Rails.application.routes.draw do
  root to: 'events#index'
  resources :events
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
