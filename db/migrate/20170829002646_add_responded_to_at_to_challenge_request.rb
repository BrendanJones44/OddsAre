class AddRespondedToAtToChallengeRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :challenge_requests, :responded_to_at, :datetime
  end
end
