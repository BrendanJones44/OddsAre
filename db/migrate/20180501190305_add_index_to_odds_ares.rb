class AddIndexToOddsAres < ActiveRecord::Migration[5.0]
  def change
    add_column :odds_ares, :task_id, :integer
    add_index :odds_ares, :task_id
  end
end
