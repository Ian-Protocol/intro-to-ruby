class Color < ApplicationRecord
    has_many :cards_colors, dependent: :destroy
    has_many :cards, through: :cards_colors

    validates :color, presence: true, uniqueness: true
end
