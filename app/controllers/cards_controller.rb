class CardsController < ApplicationController
    require 'rest-client'

    # Testing rails fetch
    def get_card
        url = "https://api.magicthegathering.io/v1/cards?page=22"
        response = RestClient.get(url)
        render json: response
    end
end
