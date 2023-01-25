class PlayerAction < ApplicationRecord

    has_many :player_action_cards
    has_many :user_cards, through: :player_action_cards

    def attacking_card
        attacking_player_action_card = self.player_action_cards.find_by(is_attacking: true)
        attacking_user_card = UserCard.find_by!(id: attacking_player_action_card.user_card_id)
        attacking_user_card.card
    end

    def attacking_user_card
        attacking_player_action_card = self.player_action_cards.find_by(is_attacking: true)
        attacking_user_card = UserCard.find_by!(id: attacking_player_action_card.user_card_id)
        attacking_user_card
    end

    def defending_card
        defending_player_action_card = self.player_action_cards.find_by(is_attacking: false)
        defending_user_card = UserCard.find_by!(id: defending_player_action_card.user_card_id)
        defending_user_card.card
    end

    def defending_user_card
        defending_player_action_card = self.player_action_cards.find_by(is_attacking: false)
        defending_user_card = UserCard.find_by!(id: defending_player_action_card.user_card_id)
        defending_user_card
    end

end
