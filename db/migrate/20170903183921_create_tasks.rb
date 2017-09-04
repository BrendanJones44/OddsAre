class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.integer :lost_user_id
      t.integer :won_user_id
      t.string :action
      t.datetime :lost_user_completed_at
      t.datetime :won_user_completed_at

      t.timestamps
    end
  end
end
