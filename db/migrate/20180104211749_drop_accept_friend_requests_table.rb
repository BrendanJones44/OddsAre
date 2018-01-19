class DropAcceptFriendRequestsTable < ActiveRecord::Migration[5.0]
  def up
    drop_table :accept_friend_requests
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
