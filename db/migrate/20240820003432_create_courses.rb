class CreateCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.string :teacher_name, null: false
      t.string :day_of_week, null: false
      t.string :course_time, null: false
      t.string :uuid, null: false
      t.string :course_code, null: false
      t.references :created_by, null: false, foreign_key:  { to_table: :users }
      t.references :school, null: false, foreign_key: true

      t.timestamps
    end
    add_index :courses, [:school_id, :course_code], unique: true
    add_index :courses, [:name, :created_by_id], unique: true
  end
end
