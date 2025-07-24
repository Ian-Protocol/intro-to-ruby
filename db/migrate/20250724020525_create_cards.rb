class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.string :card_name
      t.string :mana_cost
      t.text :description

      t.timestamps
    end
  end
end
