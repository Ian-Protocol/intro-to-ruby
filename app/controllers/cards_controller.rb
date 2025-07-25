class CardsController < ApplicationController
  def index
    @colors = Color.order(:color)
    @card_types = CardType.order(:card_type)
    @keywords = Keyword.order(:keyword)
    @cards = Card.includes(:colors, :card_types, :keywords)

    if params[:query].present?
      @cards = Card.where("card_name LIKE ?", "%#{params[:query].downcase}%")
    end

    if params[:color_id].present?
        @cards = @cards.joins(:colors).where(colors: { id: params[:color_id] })
    end

    if params[:card_type_id].present?
        @cards = @cards.joins(:card_types).where(card_types: { id: params[:card_type_id] })
    end

    if params[:keyword_id].present?
        @cards = @cards.joins(:keywords).where(keywords: { id: params[:keyword_id] })
    end

    @cards = @cards.page(params[:page]).per(20)
    # else
    #   @cards = Card.includes(:colors, :keywords, :card_types).limit(50)
    # end
  end

  def show
    @card = Card.find(params[:id])
  end
end
