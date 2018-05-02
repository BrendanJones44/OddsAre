class AddWinnerMarkedCompletedAtToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :winner_marked_completed_at, :datetime
  end
end
