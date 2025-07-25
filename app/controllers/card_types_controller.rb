class CardTypesController < ApplicationController
  def index
    @cardtypes = CardType.order(:card_type)
  end
end
