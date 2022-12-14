Rails.application.routes.draw do
  resources :games, only: [:create]
  resources :user_cards, only: [:create, :destroy]
  resources :cards, only: [:create]
  resources :users, only: [:create, :update, :destroy]

  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  post '/existingtoken', to: 'sessions#existing_token'
  post 'users/:id/gamelobby', to: 'games#create_game'
  patch 'users/:id/joingame/:game_key', to: 'games#join_game'


  # testing rails fetch
  get '/get_card', to: 'master_decks#get_card'
end
