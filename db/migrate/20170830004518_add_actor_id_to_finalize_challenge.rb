class AddActorIdToFinalizeChallenge < ActiveRecord::Migration[5.0]
  def change
    add_column :finalize_challenges, :actor_id, :integer
  end
end
