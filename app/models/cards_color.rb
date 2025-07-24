class CardsColor < ApplicationRecord
  belongs_to :card
  belongs_to :color

  # For a given card ID, each color ID must be unique.
  validates :card_id, uniqueness: { scope: :color_id }
end
