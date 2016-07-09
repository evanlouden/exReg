class CreateReasons < ActiveRecord::Migration[5.0]
  def change
    create_table :reasons do |t|
      t.string :reason, null: false
      t.boolean :teacher_paid, default: false
      t.boolean :student_charged, default: false
    end
  end
end
