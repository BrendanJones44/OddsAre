class AddOddsAreToChallengeRequests < ActiveRecord::Migration[5.0]
  def change
    add_reference :challenge_requests, :odds_are, foreign_key: true
  end
end
