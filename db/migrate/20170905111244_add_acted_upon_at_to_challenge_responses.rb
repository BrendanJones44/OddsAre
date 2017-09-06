class AddActedUponAtToChallengeResponses < ActiveRecord::Migration[5.0]
  def change
    add_column :challenge_responses, :acted_upon_at, :datetime
  end
end
