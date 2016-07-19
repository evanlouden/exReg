class TeacherInstruments < ActiveRecord::Migration[5.0]
  def change
    create_table :teacher_instruments do |t|
      t.belongs_to :teacher
      t.belongs_to :instrument
    end
  end
end
