Rails.application.routes.draw do
  resources :player_action_cards
  resources :player_actions
  resources :game_actions
  resources :user_cards, only: [:create, :destroy]
  resources :cards, only: [:create]

  resources :users, only: [:create, :update, :destroy] do
    resources :games, only: [:create]
  end

  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  post '/existingtoken', to: 'sessions#existing_token'
  post 'users/:id/creategame', to: 'games#create_game'
  patch '/joingame/:game_key', to: 'games#join_game'
  
  
  mount ActionCable.server => '/cable'
  post '/increase_counter', to: 'game_session#increase_counter'
  post '/create_random_deck', to: 'user_cards#create_random_deck'
  get '/:game_id/game_cards', to: 'user_cards#game_cards'
  post '/game/:game_id/player_actions/attack', to: 'player_actions#attack'
  post '/game/:game_id/player_actions/combat', to: 'player_actions#combat'




  # testing rails fetch
  get '/get_card', to: 'cards#get_card'
end
