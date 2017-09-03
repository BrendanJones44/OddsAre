class AddLostUserIdToChallengeResults < ActiveRecord::Migration[5.0]
  def change
    add_column :challenge_results, :lost_user_id, :integer
  end
end
