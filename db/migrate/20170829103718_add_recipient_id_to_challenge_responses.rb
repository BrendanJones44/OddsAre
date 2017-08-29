class AddRecipientIdToChallengeResponses < ActiveRecord::Migration[5.0]
  def change
    add_column :challenge_responses, :recipient_id, :integer
  end
end
