class CreateFriendRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :friend_requests do |t|
      t.integer :target_user_id
      t.integer :acting_user_id
      t.datetime :acted_upon_at

      t.timestamps
    end
  end
end
