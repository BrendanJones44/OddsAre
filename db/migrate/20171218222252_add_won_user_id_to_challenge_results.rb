class AddWonUserIdToChallengeResults < ActiveRecord::Migration[5.0]
  def change
    add_column :challenge_results, :won_user_id, :integer
  end
end
