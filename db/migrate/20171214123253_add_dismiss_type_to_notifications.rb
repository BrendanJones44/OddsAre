class AddDismissTypeToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :dismiss_type, :integer
  end
end
