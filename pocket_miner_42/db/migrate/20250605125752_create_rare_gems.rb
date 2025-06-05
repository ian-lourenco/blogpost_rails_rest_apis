class CreateRareGems < ActiveRecord::Migration[8.0]
  def change
    create_table :rare_gems do |t|
      t.string :name
      t.string :color
      t.references :miner, null: false, foreign_key: true

      t.timestamps
    end
  end
end
