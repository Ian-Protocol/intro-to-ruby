class CardsCardType < ApplicationRecord
  belongs_to :card
  belongs_to :card_type

  # No instance of double instants shall occur unless playing Storm.
  validates :card_id, uniqueness: { scope: :card_type_id }
end
