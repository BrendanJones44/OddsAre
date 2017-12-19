class AddNotificationIdToChallengeRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :challenge_requests, :notification_id, :integer
  end
end
