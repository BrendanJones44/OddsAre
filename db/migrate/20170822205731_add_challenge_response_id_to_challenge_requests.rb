class AddChallengeResponseIdToChallengeRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :challenge_requests, :challenge_response_id, :integer
  end
end
