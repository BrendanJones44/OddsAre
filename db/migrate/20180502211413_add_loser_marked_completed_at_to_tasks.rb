class AddLoserMarkedCompletedAtToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :loser_marked_completed_at, :datetime
  end
end
