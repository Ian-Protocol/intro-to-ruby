class CreateCardsKeywords < ActiveRecord::Migration[8.0]
  def change
    create_table :cards_keywords do |t|
      t.references :card, null: false, foreign_key: true
      t.references :keyword, null: false, foreign_key: true

      t.timestamps
    end
  end
end
