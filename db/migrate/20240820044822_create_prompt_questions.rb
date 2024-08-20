class CreatePromptQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :prompt_questions do |t|
      t.references :prompt, null: false, foreign_key: true
      t.string :content, null: false

      t.timestamps
    end
  end
end
