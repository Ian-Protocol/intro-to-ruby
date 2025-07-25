class CardsController < ApplicationController
  def index
    if params[:query].present?
      @cards = Card.where("card_name LIKE ?", "%#{params[:query].downcase}%")
    else
      @cards = Card.includes(:card_name, :mana_cost, :description).limit(50)
    end
  end

  def show
    @card = Card.find(params[:id])
  end
end
