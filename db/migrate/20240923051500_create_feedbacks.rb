class CreateFeedbacks < ActiveRecord::Migration[7.1]
  def change
    create_table :feedbacks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.references :course_date, null: false, foreign_key: true
      t.string :comment, null: false

      t.timestamps
    end
  end
end
