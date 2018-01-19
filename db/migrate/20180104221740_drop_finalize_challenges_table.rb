class DropFinalizeChallengesTable < ActiveRecord::Migration[5.0]
  def up
    drop_table :finalize_challenges
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
