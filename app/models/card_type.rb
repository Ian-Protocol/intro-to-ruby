class CardType < ApplicationRecord
    has_many :cards_card_types, dependent: :destroy
    has_many :cards, through: :cards_card_types

    validates :card_type, presence: true, uniqueness: true
end
