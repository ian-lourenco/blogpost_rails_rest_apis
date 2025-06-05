class CreateMiners < ActiveRecord::Migration[8.0]
  def change
    create_table :miners do |t|
      t.string :name
      t.integer :level

      t.timestamps
    end
  end
end
