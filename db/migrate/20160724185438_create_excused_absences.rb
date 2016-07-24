class CreateExcusedAbsences < ActiveRecord::Migration[5.0]
  def change
    create_table :excused_absences do |t|
      t.integer :count, null: false
    end
  end
end
