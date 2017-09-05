class AddActedUponAtToChallengeRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :challenge_requests, :acted_upon_at, :datetime
  end
end
