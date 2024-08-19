class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :uid, null: false
      t.string :name, null: false
      t.integer :user_type, null: false

      t.timestamps
    end
    add_index :users, :uid, unique: true
  end
end
