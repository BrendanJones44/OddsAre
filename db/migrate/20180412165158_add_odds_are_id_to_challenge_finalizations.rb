class AddOddsAreIdToChallengeFinalizations < ActiveRecord::Migration[5.0]
  def change
    add_column :challenge_finalizations, :odds_are_id, :integer
  end
end
