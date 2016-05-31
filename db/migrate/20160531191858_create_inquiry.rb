class CreateInquiry < ActiveRecord::Migration[5.0]
  def change
    create_table :inquiries do |t|
      t.belongs_to :student, null: false
      t.string :instrument, null: false
    end
  end
end
