class AddClickedAtToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :clicked_at, :datetime
  end
end
