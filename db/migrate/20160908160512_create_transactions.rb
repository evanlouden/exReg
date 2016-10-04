class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.decimal :amount, null: false, default: 0
      t.timestamps null: false
      t.string :type
      t.string :description, null: false
      t.belongs_to :family
      t.belongs_to :admin
    end
  end
end
