class GameSessionChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stop_all_streams
    puts "subscribed" *10
    # puts params
    game = Game.find_by(game_key: params[:game_key])
    # game_key = params[:game_key]
    # puts game
    # will create a subscription for a specific feed
    stream_for game
  end

  # def received(data)
  #   ActionCable.server.broadcast(@game)
  # end

  def unsubscribe
    # Any cleanup needed when channel is unsubscribed
    puts "unsubscribed"
    stop_all_streams

  end
end
