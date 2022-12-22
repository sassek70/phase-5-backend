class PlayerActionsController < ApplicationController



    def attack
        # game = get_game
        # user = get_user
        # card = get_card
        user = User.find(params[:player_id])
        game = Game.find(params[:game_id])
        user_card = UserCard.find_by!(card_id: params[:card_id])

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

    def defend



    end



    def combat

        defending_player = User.find(params[:player_id])
        game = Game.find_by!(id: params[:game_id])
        defending_user_card = UserCard.find_by!(card_id: params[:card_id])
        player_action = PlayerAction.where("game_id = ?", params[:game_id]).last
        defend_action_card = PlayerActionCard.create!(player_action_id: player_action.id, user_card_id: defending_user_card.id, is_attacking: false)
        # debugger
        ac = player_action.attacking_card
        dc = player_action.defending_card
        # GameSessionChannel.broadcast_to game, {action: "defense-declared", message: "#{dc.cardName} is defending the attack from #{ac.cardName}. Power: #{dc.cardPower}, Toughness: #{ac.cardDefense}"}
        # GameSessionChannel.broadcast_to game, {action: "defense-declared", message: "Processing turn"}
        
        update_player_health = 0
        damaged_player = nil
        # messages = []

        if ac.cardPower >= dc.cardDefense && dc.cardPower >= ac.cardDefense
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

            # if damaged_player == game.host_user_id
            #     game.update!(host_player_health: update_player_health)
            # elsif damaged_player == game.opponent_id
            #     game.update!(opponent_player_health: update_player_health)
            # end

            both_cards_destroyed(game.id, ac, dc)
            combat_result(game, "Both cards have been destroyed, defender loses #{update_player_health} health")

        elsif ac.cardPower > dc.cardDefense && dc.cardPower < ac.cardDefense
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
            
            
            # if damaged_player == game.host_user_id
            #     game.update!(host_player_health: update_player_health)
            # elsif damaged_player == game.opponent_id
            #     game.update!(opponent_player_health: update_player_health)
            # end
            
            combat_result(game, "Defender's #{dc.cardName} has been destroyed, defender loses #{update_player_health} health")

        elsif ac.cardPower < dc.cardDefense && dc.cardPower < ac.cardDefense
            defended_action = player_action.update!(draw: true)
            combat_result(game, "Defender's #{dc.cardName} has blocked the attack")

        elsif ac.cardPower < dc.cardDefense && dc.cardPower > ac.cardDefense
            defended_action = player_action.update!(winning_card_id: dc.id)

            update_game_cards(game.id, player_action, ac)
            combat_result(game, "Defender's #{dc.cardName} has blocked the attack. Attacker's #{ac.cardName} has been destroyed")

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

            # if damaged_player == game.host_user_id
            #     game.update!(host_player_health: update_player_health)
            # elsif damaged_player == game.opponent_id
            #     game.update!(opponent_player_health: update_player_health)
            # end

            combat_result(game, "Attack was not blocked, defender loses #{update_player_health} health")

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

    def both_cards_destroyed(game, card1, card2)
        game_cards = UserCard.where("game_id = ?", game)
        # debugger
        updated_cards = game_cards.filter{|card| card.card_id != card1.id && card.id != card2.id}
        GameSessionChannel.broadcast_to game, {action: "all-cards", game_cards: update_game_cards, card_map: get_card_map(updated_cards)}
    end

    def update_game_cards(game, player_action, destroyed_card)
        # if player_action.isAttacking == false
        #     card_to_remove = UserCard.where("id = ? ", PlayerActionCard.where("user_card_id = ?", ))
    game_cards = UserCard.where("game_id = ?", game)
    debugger
    updated_cards = game_cards.filter{|card| card.card_id != destroyed_card.id}
    GameSessionChannel.broadcast_to game, {action: "all-cards", game_cards: update_game_cards, card_map: get_card_map(updated_cards)}
    end

    def combat_result(game, messages)
        GameSessionChannel.broadcast_to game, {action: "combat-results", message: messages}
    end



end
