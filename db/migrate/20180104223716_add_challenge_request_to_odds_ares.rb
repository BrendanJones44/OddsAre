class AddChallengeRequestToOddsAres < ActiveRecord::Migration[5.0]
  def change
    add_reference :odds_ares, :challenge_request, foreign_key: true
  end
end
