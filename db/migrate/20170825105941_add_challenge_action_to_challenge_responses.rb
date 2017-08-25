class AddChallengeActionToChallengeResponses < ActiveRecord::Migration[5.0]
  def change
    add_column :challenge_responses, :challenge_action, :string
  end
end
