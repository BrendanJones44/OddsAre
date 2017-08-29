class AddFinalizedAtToChallengeResponse < ActiveRecord::Migration[5.0]
  def change
    add_column :challenge_responses, :finalized_at, :datetime
  end
end
