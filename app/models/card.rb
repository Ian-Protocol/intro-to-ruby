class Card < ApplicationRecord
    has_many :cards_colors, dependent: :destroy
    has_many :colors, through: :cards_colors

    has_many :cards_keywords, dependent: :destroy
    has_many :keywords, through: :cards_keywords

    has_many :cards_card_types, dependent: :destroy
    has_many :card_types, through: :cards_card_types

    validates :card_name, presence: true, uniqueness: true
end
