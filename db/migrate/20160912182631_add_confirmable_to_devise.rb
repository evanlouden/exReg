class AddConfirmableToDevise < ActiveRecord::Migration[5.0]
  def up
    add_column :accounts, :confirmation_token, :string
    add_column :accounts, :confirmed_at, :datetime
    add_column :accounts, :confirmation_sent_at, :datetime
    add_index :accounts, :confirmation_token, unique: true
    execute("UPDATE accounts SET confirmed_at = NOW()")
  end

  def down
    remove_columns :accounts, :confirmation_token, :confirmed_at, :confirmation_sent_at
  end
end
