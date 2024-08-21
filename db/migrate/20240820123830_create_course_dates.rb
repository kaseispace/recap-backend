class CreateCourseDates < ActiveRecord::Migration[7.1]
  def change
    create_table :course_dates do |t|
      t.references :course, null: false, foreign_key: true
      t.string :course_number, null: false
      t.string :course_date, null: false
      t.boolean :is_reflection, default: true, null: false

      t.timestamps
    end
    add_index :course_dates, [:course_id, :course_number], unique: true
    add_index :course_dates, [:course_id, :course_date], unique: true
  end
end
