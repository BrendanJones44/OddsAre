class DropOldAssociationColumnsFromChallengeResponses < ActiveRecord::Migration[5.0]
  def change
    remove_column :challenge_responses, :read_at
    remove_column :challenge_responses, :challenge_request_id
    remove_column :challenge_responses, :response_actor_number
    remove_column :challenge_responses, :challenge_action
    remove_column :challenge_responses, :recipient_id
    remove_column :challenge_responses, :finalized_at
    remove_column :challenge_responses, :actor_id
  end
end
