class RemoveFinalizedAtFromChallengeFinalizations < ActiveRecord::Migration[5.0]
  def change
    remove_column :challenge_finalizations, :finalized_at, :datetime
  end
end
