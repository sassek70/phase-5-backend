class PlayerAction < ApplicationRecord

    # has_one :user_card, as: :defending_card
    # has_one :attacking_card, class_name: "UserCard", foreign_key: :attacking_card_id 
    # has_one :defending_card, class_name: "UserCard", foreign_key: :defending_card_id 
    # has_one :user_card, class_name: "User", foreign_key: :attacking_player_id
    # has_one :user_card, class_name: "User", foreign_key: :defending_player_id

    has_many :player_action_cards
    # has_many :attacking_user_cards, through: :player_action_cards, class_name: "UserCard"
    # has_many :defending_user_cards, through: :player_action_cards, class_name: "UserCard"
    has_many :user_cards, through: :player_action_cards

    # belongs_to :game


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
