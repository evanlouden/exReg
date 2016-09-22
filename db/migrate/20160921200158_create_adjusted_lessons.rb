class CreateAdjustedLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :adjusted_lessons do |t|
      t.integer :amount, null: false
      t.date :effective_date, null: false
      t.text :reason, null: false
      t.belongs_to :lesson, null: false

      t.timestamps
    end
  end
end
