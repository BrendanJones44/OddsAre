class AddActedUponAtToChallengeResults < ActiveRecord::Migration[5.0]
  def change
    add_column :challenge_results, :acted_upon_at, :datetime
  end
end
