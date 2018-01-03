Rails.application.routes.draw do
  resources :challenge_responses
  resources :finalize_challenges
  resources :challenge_results
  #resources :accept_friend_requests

  post '/notifications/:id/mark_as_read', to: 'notifications#mark_as_read', as: 'mark_notification_as_read'

  get '/challenge_requests/show_current', to: 'challenge_requests#show_current', as: 'challenge_requests_show_current'
  resources :challenge_requests

  root to: 'pages#index'
  devise_for :users, :controllers => {:registrations => "users/registrations"}
  post '/friendship/send_request' => 'friendship#send_request', as: 'new_friend_request'
  get '/friendship/:id/show' => 'friend_requests#show', as: 'friend_request'
  get '/friendship/show_friend_requests' => 'friendship#show_friend_requests'
  post '/friendship/accept_friend_request' => 'friendship#accept_friend_request', as: 'accept_friend_request'
  get '/users/all', to: 'users#all'
  get '/users/friends', to: 'users#friends'
  get '/users/:friendly', to: 'users#show'

  get 'pages/test', to: 'pages#test'
  get 'pages/how_to_play', to: 'pages#how_to_play'
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
