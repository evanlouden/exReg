class CreatePrice < ActiveRecord::Migration[5.0]
  def change
    create_table :prices do |t|
      t.string :tier_name, null: false
      t.integer :duration, null: false
      t.decimal :price, null: false
    end
  end
end
