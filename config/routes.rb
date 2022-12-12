Rails.application.routes.draw do
  resources :games, only: [:create]
  resources :user_games, only: [:create]
  resources :user_decks, only: [:create, :destroy]
  resources :master_decks, only: [:create]
  resources :users, only: [:create, :update, :destroy]

  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'


  # testing rails fetch
  get '/get_card', to: 'master_decks#get_card'
end
