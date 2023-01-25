class PlayerActionsController < ApplicationController
    
    
    
    def attack
        user = User.find(params[:player_id])
        game = Game.find(params[:game_id])
        user_card = UserCard.find(params[:user_card_id])
        new_action = PlayerAction.create!(game_id: game.id)
        attack_action_card = PlayerActionCard.create!(player_action_id: new_action.id, user_card_id: user_card.id, is_attacking: true)
        GameSessionChannel.broadcast_to game, {action: "attack-declared", player_action: PlayerActionSerializer.new(new_action), message: "#{user.username} is attacking with #{user_card.card.cardName}. Power: #{user_card.card.cardPower}, Toughness: #{user_card.card.cardDefense}"}
        head :ok
    end
    
    # case 1 = neither card dies = working
    # case 2 = both cards die = TESTED & WORKING
    # case 3 = attacking card dies & all damaged blocked = TESTED & WORKING
    # case 4 = attacking card dies & some damaged blocked
    # case 5 = defending card dies & all damaged blocked = TESTED 1/3 VS 1/2. 1/3 WAS DESTROYED????
    # case 6 = defending card dies & some damaged blocked = working
    # case 7 = no defending card = working
    # case 8 = no attacking cards available = edge case

    
    def combat
        
        defending_player = User.find(params[:player_id])
        game = Game.find_by!(id: params[:game_id])
        player_action = PlayerAction.where("game_id = ?", params[:game_id]).last
        ac = player_action.attacking_card
        
        if !params[:user_card_id]
            no_defense(game, player_action, defending_player, ac)
            return
        end
        
        defending_user_card = UserCard.find(params[:user_card_id])
        defend_action_card = PlayerActionCard.create!(player_action_id: player_action.id, user_card_id: defending_user_card.id, is_attacking: false)
        dc = player_action.defending_card
        GameSessionChannel.broadcast_to game, {action: "defense-declared", message: "#{dc.cardName} is defending the attack from #{ac.cardName}. Power: #{dc.cardPower}, Toughness: #{dc.cardDefense}"}
        GameSessionChannel.broadcast_to game, {action: "defense-declared", message: "Processing turn"}
        
# ******************************************************CASE 1 CASE 1 CASE 1 CASE 1***************************************************** #
    # case 1 = neither card dies = working
        
        if ac.cardPower < dc.cardDefense && dc.cardPower < ac.cardDefense
            defended_action = player_action.update!(draw: true)
            combat_result(game, player_action.attacking_user_card.user, "#{player_action.defending_user_card.user.username}'s #{dc.cardName} #{dc.cardPower}/#{dc.cardDefense} has completely blocked the attack")
        
        
# ******************************************************CASE 2 CASE 2 CASE 2 CASE 2***************************************************** #
    # case 2 = both cards die = working
        elsif ac.cardPower == dc.cardDefense && dc.cardPower >= ac.cardDefense
            defended_action = player_action.update!(both_destroyed: true)
            unblocked_damage = ac.cardPower - dc.cardDefense
            both_cards_destroyed(game.id, player_action)
            combat_result(game, player_action.attacking_user_card.user, "Both cards have been destroyed A:#{ac.cardPower}/#{ac.cardDefense}, D: #{dc.cardPower}/#{dc.cardDefense}, #{player_action.defending_user_card.user.username}")

# ******************************************************CASE 3 CASE 3 CASE 3 CASE 3***************************************************** #
    # case 3 = attacking card dies & all damaged blocked = working

        elsif ac.cardPower < dc.cardDefense && dc.cardPower >= ac.cardDefense
            defended_action = player_action.update!(winning_card_id: dc.id)
            update_game_cards(game.id, player_action, ac)
            combat_result(game, player_action.attacking_user_card.user, "#{player_action.defending_user_card.user.username}'s #{dc.cardName} #{dc.cardPower}/#{dc.cardDefense} has blocked the attack. #{player_action.attacking_user_card.user.username}'s #{ac.cardName} #{ac.cardPower}/#{ac.cardDefense} has been destroyed")            

# ******************************************************CASE 4 CASE 4 CASE 4 CASE 4***************************************************** #
    # case 4 = both cards die & some damaged blocked

        elsif ac.cardPower > dc.cardDefense && dc.cardPower >= ac.cardDefense
            defended_action = player_action.update!(winning_card_id: ac.id, both_destroyed: true)
            unblocked_damage = ac.cardPower - dc.cardDefense
            health_update(defending_player, game, unblocked_damage)
            combat_result(game, player_action.attacking_user_card.user, "#{player_action.attacking_user_card.user.username}'s #{ac.cardName} #{ac.cardPower}/#{ac.cardDefense} was destroyed in the attack by #{player_action.defending_user_card.user.username}'s #{dc.cardName} #{dc.cardPower}/#{dc.cardDefense}. Remaining #{unblocked_damage} damage has been dealt to #{player_action.defending_user_card.user.username}")

# ******************************************************CASE 5 CASE 5 CASE 5 CASE 5***************************************************** #
    # case 5 = defending card dies & all damaged blocked
            
        elsif ac.cardPower == dc.cardDefense && dc.cardPower < ac.cardDefense 
            defended_action = player_action.update!(winning_card_id: ac.id)
            update_game_cards(game.id, player_action, dc)
            combat_result(game, player_action.attacking_user_card.user, "#{player_action.defending_user_card.user.username}'s #{dc.cardName} #{dc.cardPower}/#{dc.cardDefense} was destroyed blocking the attacking #{ac.cardName} #{ac.cardPower}/#{ac.cardDefense}.")    

# ******************************************************CASE 6 CASE 6 CASE 6 CASE 6***************************************************** #
    # case 6 = defending card dies & some damaged blocked = working
        elsif ac.cardPower > dc.cardDefense && dc.cardPower < ac.cardDefense
            defended_action = player_action.update!(winning_card_id: ac.id, destroyed_card_id: dc.id)
            unblocked_damage = ac.cardPower - dc.cardDefense
            update_game_cards(game.id, player_action, dc)
            health_update(defending_player, game, unblocked_damage)
            combat_result(game, player_action.attacking_user_card.user, "#{player_action.defending_user_card.user.username}'s #{dc.cardName} #{dc.cardPower}/#{dc.cardDefense} has been destroyed by attacking #{ac.cardPower}/#{ac.cardDefense}. Remaining #{unblocked_damage} damage has been dealt to #{player_action.defending_user_card.user.username}")
        end
    end

# ******************************************************CASE 7 CASE 7 CASE 7 CASE 7***************************************************** #
    # case 7 = no defending card = working

        def no_defense(game, player_action, defending_player, ac)
            health_update(defending_player, game, ac.cardPower)
            combat_result(game, player_action.attacking_user_card.user, "Attack #{ac.cardPower}/#{ac.cardDefense} was not blocked, defender lost #{ac.cardPower} health")
        end

# ******************************************************CASE 8 CASE 8 CASE 8 CASE 8***************************************************** #
    # case 8 = no attacking cards available = edge case
        def skip_turn 
            player = User.find_by!(id: params[:player_id])
            game = Game.find_by!(id: params[:game_id])
            new_action = PlayerAction.create!(game_id: game.id, skipped: true)
            combat_result(game, player, "#{player.username} has skipped their turn")
        end

    private

    def results(game, winning_user_id)
        winner = User.find(winning_user_id)
        increase_wins = winner.gamesWon + 1
        update_rate = (increase_wins.to_f / winner.gamesPlayed.to_f) * 100
        if winning_user_id == game.host_user_id
            game.update!(winning_player_id: winner.id, opponent_player_health: 0)
        else
            game.update!(winning_player_id: winner.id, host_player_health: 0)
        end
        winner.update!(gamesWon: increase_wins, win_rate: update_rate.round(2))
    end

    def get_card_map(game_cards)
        game_cards.each_with_object({}) do |game_card,hash|
            hash[game_card.id] = game_card.card
        end
    end

    def both_cards_destroyed(game, player_action)
        player_action.attacking_user_card.update!(isActive: false)
        player_action.defending_user_card.update!(isActive: false)
        GameSessionChannel.broadcast_to game, {action: "update-cards", destroyed_user_cards: [player_action.attacking_user_card,player_action.defending_user_card].map{|user_card| UserCardSerializer.new(user_card)}}
        return
    end

    def update_game_cards(game, player_action, destroyed_card)
        if destroyed_card.id == player_action.attacking_card.id 
            player_action.attacking_user_card.update!(isActive: false)
            GameSessionChannel.broadcast_to game, {action: "update-cards", destroyed_user_cards: [UserCardSerializer.new(player_action.attacking_user_card)]}

        else destroyed_card.id == player_action.defending_card.id
            player_action.defending_user_card.update!(isActive: false)
            GameSessionChannel.broadcast_to game, {action: "update-cards", destroyed_user_cards: [UserCardSerializer.new(player_action.defending_user_card)]}

        end
        return 
    end

    def combat_result(game, attacking_player, messages)
        GameSessionChannel.broadcast_to game, {action: "combat-results", attacking_player: attacking_player.id, message: messages}
    end

    def health_update(defending_player, game, unblocked_damage)
        if defending_player.id == game.opponent_id
            updated_player_health = game.opponent_player_health - unblocked_damage
            if updated_player_health <= 0
                results(game, game.host_user_id)
            else
                game.update!(opponent_player_health: updated_player_health)
            end
            GameSessionChannel.broadcast_to game, {action: "update-health", player: "opponent", health: updated_player_health}
        elsif defending_player.id == game.host_user_id
            updated_player_health = game.host_player_health - unblocked_damage
            if updated_player_health <= 0
                results(game, game.opponent_id)
            else
                game.update!(host_player_health: updated_player_health)
            end
            GameSessionChannel.broadcast_to game, {action: "update-health", player: "host", health: updated_player_health}
        end
    end

end
