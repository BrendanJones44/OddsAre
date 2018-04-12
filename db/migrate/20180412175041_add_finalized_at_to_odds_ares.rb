class AddFinalizedAtToOddsAres < ActiveRecord::Migration[5.0]
  def change
    add_column :odds_ares, :finalized_at, :datetime
  end
end
