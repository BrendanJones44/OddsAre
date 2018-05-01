class AddIndexToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :odds_are_id, :integer
    add_index :tasks, :odds_are_id
  end
end
