class DropChallengeResultsTable < ActiveRecord::Migration[5.0]
  def up
    drop_table :challenge_results
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
