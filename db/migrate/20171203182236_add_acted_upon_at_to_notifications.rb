class AddActedUponAtToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :acted_upon_at, :datetime
  end
end
