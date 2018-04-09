class ChangeColumnNameForChallengeResponse < ActiveRecord::Migration[5.0]
  def change
      rename_column :challenge_responses, :response_out_of, :odds_out_of
  end
end
