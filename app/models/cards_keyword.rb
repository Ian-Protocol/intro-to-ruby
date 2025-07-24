class CardsKeyword < ApplicationRecord
  belongs_to :card
  belongs_to :keyword

  # Each keyword should only appear once per card.
  # Multiple instances of lifelink on the same creature are redundant. 
  validates :card_id, uniqueness: { scope: :keyword_id }
end
