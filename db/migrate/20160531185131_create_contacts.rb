class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.boolean :primary, default: true
      t.belongs_to :teacher
      t.belongs_to :admin
      t.belongs_to :family
    end
  end
end
