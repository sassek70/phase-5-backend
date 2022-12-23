class PlayerActionsController < ApplicationController
    
    
    
    def attack
        # game = get_game
        # user = get_user
        # card = get_card
        user = User.find(params[:player_id])
        game = Game.find(params[:game_id])
        user_card = UserCard.find_by!(card_id: params[:card_id], game_id: game.id)
        
        # p game
        # p user
        # p card
        # debugger
        # attacking_player_id: user.id, attacking_card_id: user_card.id,
        new_action = PlayerAction.create!(game_id: game.id)
        attack_action_card = PlayerActionCard.create!(player_action_id: new_action.id, user_card_id: user_card.id, is_attacking: true)
        # debugger 
        # relationship issue causing line 20 to through errors
        GameSessionChannel.broadcast_to game, {action: "attack-declared", player_action: PlayerActionSerializer.new(new_action), message: "#{user.username} is attacking with #{user_card.card.cardName}. Power: #{user_card.card.cardPower}, Toughness: #{user_card.card.cardDefense}"}
        head :ok
    end
    
    
    
    # case 1 = neither card dies = working
    # case 2 = both cards die = working
    # case 3 = attacking card dies & all damaged blocked = working
    # case 4 = attacking card dies & some damaged blocked
    # case 5 = defending card dies & all damaged blocked
    # case 6 = defending card dies & some damaged blocked = working
    # case 7 = no defending card = working
    # case 8 = no attacking cards available = edge case
    
    
    def combat
        
        defending_player = User.find(params[:player_id])
        game = Game.find_by!(id: params[:game_id])
        defending_user_card = UserCard.find_by!(card_id: params[:card_id], game_id: game.id)
        player_action = PlayerAction.where("game_id = ?", params[:game_id]).last
        defend_action_card = PlayerActionCard.create!(player_action_id: player_action.id, user_card_id: defending_user_card.id, is_attacking: false)
        # debugger
        ac = player_action.attacking_card
        dc = player_action.defending_card
        GameSessionChannel.broadcast_to game, {action: "defense-declared", message: "#{dc.cardName} is defending the attack from #{ac.cardName}. Power: #{dc.cardPower}, Toughness: #{ac.cardDefense}"}
        GameSessionChannel.broadcast_to game, {action: "defense-declared", message: "Processing turn"}
        
        update_player_health = 0
        damaged_player = nil
        # messages = []
        
# ******************************************************CASE 1 CASE 1 CASE 1 CASE 1***************************************************** #
    # case 1 = neither card dies = working
        
        if ac.cardPower < dc.cardDefense && dc.cardPower < ac.cardDefense
            defended_action = player_action.update!(draw: true)
            combat_result(game, player_action.attacking_user_card.user, "#{player_action.defending_user_card.user.username}'s #{dc.cardName} has completely blocked the attack")
        
        
# ******************************************************CASE 2 CASE 2 CASE 2 CASE 2***************************************************** #
    # case 2 = both cards die = working
        elsif ac.cardPower >= dc.cardDefense && dc.cardPower >= ac.cardDefense
            defended_action = player_action.update!(both_destroyed: true)
            unblocked_damage = ac.cardPower - dc.cardDefense

            if defending_player.id == game.opponent_id
                damaged_player = game.opponent_id
                update_player_health = game.opponent_player_health - unblocked_damage
                game.update!(opponent_player_health: update_player_health)
                GameSessionChannel.broadcast_to game, {action: "update-health", player: "opponent", health: update_player_health}
            elsif defending_player.id == game.host_user_id
                damaged_player = game.host_user_id
                update_player_health = game.host_player_health - unblocked_damage
                game.update!(host_player_health: update_player_health)
                GameSessionChannel.broadcast_to game, {action: "update-health", player: "host", health: update_player_health}
            end

            both_cards_destroyed(game.id, player_action)
            combat_result(game, player_action.attacking_user_card.user, "Both cards have been destroyed A:#{player_action.attacking_user_card.id}, D: #{player_action.defending_user_card.id}, #{player_action.defending_user_card.user.username} loses #{update_player_health} health")

# ******************************************************CASE 3 CASE 3 CASE 3 CASE 3***************************************************** #
    # case 3 = attacking card dies & all damaged blocked = working

        elsif ac.cardPower < dc.cardDefense && dc.cardPower > ac.cardDefense
            defended_action = player_action.update!(winning_card_id: dc.id)

            update_game_cards(game.id, player_action, ac)
            combat_result(game, player_action.attacking_user_card.user, "#{player_action.defending_user_card.user.username}'s #{dc.cardName} has blocked the attack. #{player_action.attacking_user_card.user.username}'s #{ac.cardName} has been destroyed")            



# ******************************************************CASE 4 CASE 4 CASE 4 CASE 4***************************************************** #
    # case 4 = attacking card dies & some damaged blocked

        elsif ac.cardPower > dc.cardDefense && dc.cardPower >= ac.cardDefense
            defended_action = player_action.update!(winning_card_id: ac.id, both_destroyed: true)
            
            both_cards_destroyed(game.id, player_action)
            combat_result(game, player_action.attacking_user_card.user, "#{player_action.attacking_user_card.user.username}'s #{ac.cardName} was destroyed in the attack by #{player_action.defending_user_card.user.username}'s #{dc.cardName}. Remaining #{update_player_health} damage has been dealt to #{player_action.defending_user_card.user.username}")



# ******************************************************CASE 5 CASE 5 CASE 5 CASE 5***************************************************** #
    # case 5 = defending card dies & all damaged blocked
            
        elsif ac.cardPower = dc.cardDefense && dc.cardPower < ac.cardDefense 
            defended_action = player_action.update!(winning_card_id: ac.id)

            update_game_cards(game.id, player_action, dc)
            combat_result(game, player_action.attacking_user_card.user, "#{player_action.defending_user_card.user.username}'s #{dc.cardName} was destroyed blocking the attack. Remaining #{update_player_health} damage has been dealt to #{player_action.defending_user_card.user.username}")    


# ******************************************************CASE 6 CASE 6 CASE 6 CASE 6***************************************************** #
    # case 6 = defending card dies & some damaged blocked = working
        elsif ac.cardPower >= dc.cardDefense && dc.cardPower < ac.cardDefense
            defended_action = player_action.update!(winning_card_id: ac.id, destroyed_card_id: dc.id)
            unblocked_damage = ac.cardPower - dc.cardDefense
            update_game_cards(game.id, player_action, dc)

            if defending_player.id == game.opponent_id
                damaged_player = game.opponent_id
                update_player_health = game.opponent_player_health - unblocked_damage
                game.update!(opponent_player_health: update_player_health)
                GameSessionChannel.broadcast_to game, {action: "update-health", player: "opponent", health: update_player_health}
            elsif defending_player.id == game.host_user_id
                damaged_player = game.host_user_id
                update_player_health = game.host_player_health - unblocked_damage
                game.update!(host_player_health: update_player_health)
                GameSessionChannel.broadcast_to game, {action: "update-health", player: "host", health: update_player_health}
            end

            combat_result(game, player_action.attacking_user_card.user, "#{player_action.defending_user_card.user.username}'s #{dc.cardName} has been destroyed. Remaining #{update_player_health} damage has been dealt to #{player_action.defending_user_card.user.username}")


# ******************************************************CASE 7 CASE 7 CASE 7 CASE 7***************************************************** #
    # case 7 = no defending card = working

        elsif !dc
            defended_action = player_action.update!(winning_card_id: ac.id, unblocked_attack: true)
            unblocked_damage = ac.cardPower


            if defending_player.id == game.opponent_id
                damaged_player = game.opponent_id
                update_player_health = game.opponent_player_health - unblocked_damage
                game.update!(opponent_player_health: update_player_health)
                GameSessionChannel.broadcast_to game, {action: "update-health", player: "opponent", health: update_player_health}
            elsif defending_player.id == game.host_user_id
                damaged_player = game.host_user_id
                update_player_health = game.host_player_health - unblocked_damage
                game.update!(host_player_health: update_player_health)
                GameSessionChannel.broadcast_to game, {action: "update-health", player: "host", health: update_player_health}
            end

            combat_result(game, player_action.attacking_user_card.user, "Attack was not blocked, #{player_action.defending_user_card.user.username} lost #{update_player_health} health")



# ******************************************************CASE 7 CASE 7 CASE 7 CASE 7***************************************************** #
    # case 8 = no attacking cards available = edge case
        elsif !ac
            combat_result(game, player_action.attacking_user_card.user, "#{player_action.attacking_user_card.user.username} has no cards left")
        end
    end


                




            # defended_action = player_action.update!(defending_player_id: params[:player_id], defending_card_id: params[:card_id], winning_card_id: dc.id, destroyed_card_id: ac.id)





    private

    # def get_game
    #     game = Game.find(params[:game_id])
    #     game
    # end

    # def get_user
    #     user = User.find(params[:player_id])
    #     user
    # end

    # def get_card
    #     card = Card.find(params[:card_id])
    #     card
    #     # debugger
    # end

    def get_card_map(game_cards)
        # start with empty object, for each game card, create an adding to the empty object as 
        game_cards.each_with_object({}) do |game_card,hash|
            hash[game_card.id] = game_card.card
        end
    end

    def both_cards_destroyed(game, player_action)
        player_action.attacking_user_card.update!(isActive: false)
        player_action.defending_user_card.update!(isActive: false)
        # debugger
        # updated_cards = game_cards.filter{|card| card.card_id != card1.id && card.id != card2.id}
        user_cards = UserCard.where("game_id = ?", game)
        # GameSessionChannel.broadcast_to game, {action: "update-cards", game_cards: updated_cards.map{|game_card| UserCardSerializer.new(game_card)}, card_map: get_card_map(updated_cards)}
        GameSessionChannel.broadcast_to game, {action: "update-cards", game_cards: user_cards.map{|user_card| UserCardSerializer.new(user_card)}, card_map: get_card_map(user_cards)}

    end

    def update_game_cards(game, player_action, destroyed_card)
        if destroyed_card.id == player_action.attacking_card.id 
            player_action.attacking_user_card.update!(isActive: false)
        else destroyed_card.id == player_action.defending_card.id
            player_action.defending_user_card.update!(isActive: false)
        end
        user_cards = UserCard.where("game_id = ?", game)
        # updated_cards = game_cards.filter{|card| card.card_id != destroyed_card.id}
        GameSessionChannel.broadcast_to game, {action: "update-cards", game_cards: user_cards.map{|user_card| UserCardSerializer.new(user_card)}, card_map: get_card_map(user_cards)}
    end

    def combat_result(game, attacking_player, messages)
        GameSessionChannel.broadcast_to game, {action: "combat-results", attacking_player: attacking_player, message: messages}
    end



end
