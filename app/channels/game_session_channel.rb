class GameSessionChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    puts "subscribed" *10
    game = Game.find_by(game_key: params[:game_key])
    stream_for game
  end

  def received(data)
    game = Game.find_by(game_key: params[:game_key])
    ActionCable.server.broadcast(game, data)
  end

  def unsubscribe
    puts "unsubscribed"
    stop_all_streams
  end
  
end
