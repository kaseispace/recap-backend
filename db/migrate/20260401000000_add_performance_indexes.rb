class AddPerformanceIndexes < ActiveRecord::Migration[7.1]
  def change
    add_index :reflections, %i[user_id course_id]
    add_index :reflections, %i[course_id course_date_id]
    add_index :feedbacks, %i[user_id course_id]
    add_index :prompts, %i[course_id active]
    add_index :user_courses, %i[user_id course_id], unique: true
  end
end
