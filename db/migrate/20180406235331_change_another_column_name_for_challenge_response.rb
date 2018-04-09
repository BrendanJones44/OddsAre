class ChangeAnotherColumnNameForChallengeResponse < ActiveRecord::Migration[5.0]
  def change
    rename_column :challenge_responses, :target_number, :number_chosen
  end
end
