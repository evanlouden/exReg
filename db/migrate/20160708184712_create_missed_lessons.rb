class CreateMissedLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :missed_lessons do |t|
      t.datetime :date, null: false
      t.belongs_to :lesson, null: false
      t.belongs_to :reason, null: false
    end
  end
end
