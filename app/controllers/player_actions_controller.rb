class PlayerActionsController < ApplicationController



    def attack
        # game = get_game
        # user = get_user
        # card = get_card
        user = User.find(params[:player_id])
        game = Game.find(params[:game_id])
        user_card = UserCard.find_by!(id: params[:card_id])

        # p game
        # p user
        # p card
        # debugger
        new_action = PlayerAction.create!(attacking_player_id: user.id, attacking_card_id: user_card.id, game_id: game.id)
        debugger 
        # relationship issue causing line 20 to through errors
        GameSessionChannel.broadcast_to game, {action: "attack-declared", player_action: PlayerActionSerializer.new(new_action), power: user_card.card.cardPower, toughness: user_card.card.cardDefense}
        render json: card, status: :ok
    end

    def defend
    end



    def combat
        attack_action = PlayerAction.last.find_by(game_id: params[:game_id])
        game = Game.find_by!(id: params[:game_id])
        ac = Card.find_by!(id: attack_action.attacking_card_id)
        dc = Card.find_by!(id: params[:card_id])
        update_player_health = 0
        damaged_player = nil
        messages = []

        if ac.cardPower >= dc.cardDefense && dc.cardPower >= ac.cardDefense
            defended_action = attack_action.update!(defending_player_id: params[:player_id], defending_card_id: params[:card_id], both_destroyed: true)
            unblocked_damage = ac.cardPower - dc.cardDefense

            if defending_player == game.opponent_id
                damaged_player = game.opponent_id
                update_player_health = game.opponent_player_health - unblocked_damage
            elsif defending_player == game.host_user_id
                damaged_player = game.host_user_id
                update_player_health = game.host_player_health - unblocked_damage
            end

            if damaged_player == game.host_user_id
                game.update!(host_player_health: update_player_health)
            elsif damaged_player == game.opponent_id
                game.update!(opponent_player_health: update_player_health)
            end

            update_game_cards(game.id, ac, dc)
            combat_result(game, "Both cards have been destroyed, defender loses #{update_player_health} health")

        elsif ac.cardPower > dc.cardDefense && dc.cardPower < ac.cardDefense
            defended_action = attack_action.update!(defending_player_id: params[:player_id], defending_card_id: params[:card_id], winning_card_id: ac.id, destroyed_card_id: dc.id)
            unblocked_damage = ac.cardPower - dc.cardDefense
            update_game_cards(game.id, dc)

            if defending_player == game.opponent_id
                damaged_player = game.opponent_id
                update_player_health = game.opponent_player_health - unblocked_damage
            elsif defending_player == game.host_user_id
                damaged_player = game.host_user_id
                update_player_health = game.host_player_health - unblocked_damage
            end
            
            
            if damaged_player == game.host_user_id
                game.update!(host_player_health: update_player_health)
            elsif damaged_player == game.opponent_id
                game.update!(opponent_player_health: update_player_health)
            end
            
            combat_result(game, "Defender's #{dc.cardName} has been destroyed, defender loses #{update_player_health} health")

        elsif ac.cardPower < dc.cardDefense && dc.cardPower < ac.cardPower
            defended_action = attack_action.update!(draw: true)
            combat_result(game, "Defender's #{dc.cardName} has blocked the attack")

        elsif !dc
            defended_action = attack_action.update!(defending_player_id: params[:player_id], winning_card_id: ac.id, unblocked_attack: true)
            unblocked_damage = ac.cardPower


            if defending_player == game.opponent_id
                damaged_player = game.opponent_id
                update_player_health = game.opponent_player_health - unblocked_damage
            elsif defending_player == game.host_user_id
                damaged_player = game.host_user_id
                update_player_health = game.host_player_health - unblocked_damage
            end

            if damaged_player == game.host_user_id
                game.update!(host_player_health: update_player_health)
            elsif damaged_player == game.opponent_id
                game.update!(opponent_player_health: update_player_health)
            end

            combat_result(game, "Attack was not blocked, defender loses #{update_player_health} health")

        end
    end


                




            # defended_action = attack_action.update!(defending_player_id: params[:player_id], defending_card_id: params[:card_id], winning_card_id: dc.id, destroyed_card_id: ac.id)





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
        game_cards = UserCard.where("game_id = ?", game.id)
        updated_cards = game_cards.filter{|card| card.id != card1.id && card.id != card2.id}
        GameSessionChannel.broadcast_to game, {action: "all-cards", game_cards: update_game_cards, card_map: get_card_map(updated_cards)}
    end

    def update_game_cards(game, destroyed_card)
    game_cards = UserCard.where("game_id = ?", game.id)
    updated_cards = game_cards.filter{|card| card.id != destroyed_card.id}
    GameSessionChannel.broadcast_to game, {action: "all-cards", game_cards: update_game_cards, card_map: get_card_map(updated_cards)}
    end

    def combat_result(game, messages)
        GameSessionChannel.broadcast_to game, {action: "combat-results", message: messages}
    end



end
