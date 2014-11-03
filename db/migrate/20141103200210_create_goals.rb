class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.references :user, index: true
      t.text :body
      t.string :status

      t.timestamps
    end
  end
end
