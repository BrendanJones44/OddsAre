class DropOldAssociationColumnsFromChallengeRequests < ActiveRecord::Migration[5.0]
  def up
    remove_column :challenge_requests, :recipient_id
    remove_column :challenge_requests, :actor_id
    remove_column :challenge_requests, :read_at
    remove_column :challenge_requests, :challenge_response_id
    remove_column :challenge_requests, :responded_to_at
  end
end
