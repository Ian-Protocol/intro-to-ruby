class CardsController < ApplicationController
  def index
    @cards = Card.includes(:colors, :keywords, :card_types).limit(50)
  end

  def show
    @card = Card.find(params[:id])
  end
end
