class Keyword < ApplicationRecord
    has_many :cards_keywords, dependent: :destroy
    has_many :cards, through: :cards_keywords

    validates :keyword, presence: true, uniqueness: true
end
