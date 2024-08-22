class CreateReflections < ActiveRecord::Migration[7.1]
  def change
    create_table :reflections do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.references :course_date, null: false, foreign_key: true
      t.string :message, null: false
      t.string :message_type, null: false
      t.float :message_time, null: false

      t.timestamps
    end
  end
end
