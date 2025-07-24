class CreateCardsColors < ActiveRecord::Migration[8.0]
  def change
    create_table :cards_colors do |t|
      t.references :card, null: false, foreign_key: true
      t.references :color, null: false, foreign_key: true

      t.timestamps
    end
  end
end
