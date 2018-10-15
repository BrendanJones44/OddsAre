Rails.application.routes.draw do
  resources :challenge_responses
  resources :challenge_finalizations
  get '/odds_ares/show_current',
   to: 'odds_ares#show_current', as: 'odds_ares_show_current'
  get '/odds_ares/show_completed',
    to: 'odds_ares#show_completed', as: 'odds_ares_show_completed'
  resources :odds_ares
  resources :challenge_requests

  root to: 'pages#index'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  post '/notifications/:id/mark_as_read' =>
   'notifications#mark_as_read', as: 'mark_notification_as_read'

  post '/friendship/send_friend_request' =>
   'friendship#send_friend_request', as: 'send_friend_request'
  get '/friendship/show_friend_requests' =>
  'friendship#show_friend_requests'
  post '/friendship/accept_friend_request' =>
   'friendship#accept_friend_request', as: 'accept_friend_request'
  get '/users/all', to: 'users#all'
  get '/users/friends', to: 'users#friends'
  get '/users/search', to: 'users#search'
  get '/users/settings', to: 'users#settings'

  get 'pages/test', to: 'pages#test'
  get 'pages/how_to_play', to: 'pages#how_to_play'
  get '/users/:friendly', to: 'users#show'
  get '/tasks/show_lost', to: 'tasks#show_lost'
  post '/tasks/mark_as_done_from_loser', to: 'tasks#mark_as_done_from_loser', as: 'mark_task_as_done_from_loser'
  post '/tasks/mark_as_done_from_winner', to: 'tasks#mark_as_done_from_winner', as: 'mark_task_as_done_from_winner'
  get '/tasks/:task_id', to: 'tasks#show'
  resources :tasks
  resources :users
end
