class GameSessionChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    puts "subscribed" *10
    # puts params
    game = Game.find_by(game_key: params[:game_key])
    # game_key = params[:game_key]
    # puts game
    # will create a subscription for a specific feed
    stream_for game
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    puts "unsubscribed"
    stop_all_streams

  end
end
