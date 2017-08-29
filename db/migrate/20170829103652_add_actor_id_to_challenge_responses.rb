class AddActorIdToChallengeResponses < ActiveRecord::Migration[5.0]
  def change
    add_column :challenge_responses, :actor_id, :integer
  end
end
