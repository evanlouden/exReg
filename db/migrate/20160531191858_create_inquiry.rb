class CreateInquiry < ActiveRecord::Migration[5.0]
  def change
    create_table :inquiries do |t|
      t.belongs_to :student, null: false
      t.string :instrument, null: false
      t.text :notes
      t.boolean :completed, default: false
      t.timestamps null: false
    end
  end
end
