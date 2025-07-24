class CreateCardTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :card_types do |t|
      t.string :card_type

      t.timestamps
    end
  end
end
