class AddOddsAreIdToChallengeResponses < ActiveRecord::Migration[5.0]
  def change
    add_column :challenge_responses, :odds_are_id, :integer
  end
end
