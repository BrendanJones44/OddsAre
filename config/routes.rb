Rails.application.routes.draw do
  resources :challenge_responses
  resources :finalize_challenges
  resources :challenge_results
  resources :friend_requests
  resources :accept_friend_requests

  get '/notifications.json' => 'notifications#index'
  resources :notifications do
    collection do
      post :mark_as_read
    end
  end
  resources :challenge_requests
  root to: 'pages#index'
  devise_for :users, :controllers => {:registrations => "users/registrations"}
  get '/friendship/send_request' => 'friendship#send_request'
  get '/friendship/show_friend_requests' => 'friendship#show_friend_requests'
  get '/friendship/accept_friend_request' => 'friendship#accept_friend_request'
  get '/users/all', to: 'users#all'
  get '/users/:friendly', to: 'users#show'

  get 'pages/test', to: 'pages#test'
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
