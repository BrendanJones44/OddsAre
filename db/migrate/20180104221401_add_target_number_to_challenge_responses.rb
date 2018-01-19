class AddTargetNumberToChallengeResponses < ActiveRecord::Migration[5.0]
  def change
    add_column :challenge_responses, :target_number, :integer
  end
end
