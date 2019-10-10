Rails.application.routes.draw do
  get 'notifications/index'
  root to: 'home#index'
  get '/home/index', to: 'home#index'
  post '/accept', to: 'events#accept'
  get '/absent', to: 'events#absent'
  get '/calendar/access', to: 'calendars#access_calender'
  get '/users/:user_id', to: 'home#index'
  # get 'gcals/get_google_calendar_event', to: 'gcals#get_google_calendar_event'
  # get '/gcal/redirect', to: 'gcals#redirect'
  # get '/gcal/callback', to: 'gcals#callback'
  # get '/calendars', to: 'gcals#calendars', as: 'calendars'
  # get '/events/:calendar_id', to: 'gcals#events', as: 'events', calendar_id: /[^\/]+/
  # post '/events/:calendar_id', to: 'gcals#new_event', as: 'new_event', calendar_id: /[^\/]+/
  resources :events
  resources :calendars
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'signup', to: 'devise/registrations#new'
    get 'login', to: 'devise/sessions#new'
    post 'login', to: 'devise/sessions#create'
    delete 'logout', to: 'devise/sessions#destroy'
  end
end
