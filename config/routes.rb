Rails.application.routes.draw do
  root to: 'home#index'
  get '/home/index',          to: 'home#index'
  get '/about',               to: 'home#about'
  get '/notifications/index', to: 'notifications#index'
  post '/accept',             to: 'events#accept'
  get '/absent',              to: 'events#absent'
  get '/setting/calendar',    to: 'calendars#setting'
  get '/calendar/access',     to: 'calendars#access_calender'
  get '/events/date/search',  to: 'events#date_search', as: 'date_search'
  get '/users/:user_id',      to: 'home#index'
  get 'search',               to: 'home#search_user'
  resources :events
  resources :calendars, only: [:new, :create, :edit, :update, :destroy]
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations' }
  devise_scope :user do
    get 'signup', to: 'users/registrations#new'
    post 'signup', to: 'users/registrations#create'
    get 'setting/profile', to: 'users/registrations#edit'
    patch 'setting/profile', to: 'users/registrations#update'
    delete 'delete', to: 'users/registrations#destroy'
    get 'login', to: 'devise/sessions#new'
    post 'login', to: 'devise/sessions#create'
    delete 'logout', to: 'devise/sessions#destroy'
  end
  resource :user, only: [:edit] do
    collection do
      patch 'update_password'
    end
  end
end
