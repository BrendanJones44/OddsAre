class AddChallengeOutOfToFinalizeChallenge < ActiveRecord::Migration[5.0]
  def change
    add_column :finalize_challenges, :challenge_out_of, :integer
  end
end
