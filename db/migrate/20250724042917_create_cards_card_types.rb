class CreateCardsCardTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :cards_card_types do |t|
      t.references :card, null: false, foreign_key: true
      t.references :card_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
