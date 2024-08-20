class CreatePrompts < ActiveRecord::Migration[7.1]
  def change
    create_table :prompts do |t|
      t.references :course, null: false, foreign_key: true
      t.string :title, null: false
      t.boolean :active, null: false, default: false

      t.timestamps
    end
  end
end
