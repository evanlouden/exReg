class CreateStudents < ActiveRecord::Migration[5.0]
  def change
    create_table :students do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :school
      t.date :dob, null: false
      t.belongs_to :family
    end
  end
end
