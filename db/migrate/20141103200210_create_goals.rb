class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.references :user, index: true, null: false
      t.text :body, null: false
      t.string :status, null: false, default: "PRIVATE"

      t.timestamps
    end
    
    add_index :goals, [:user_id, :body], unique: true
  end
end
