class AddRespondedToAtToOddsAres < ActiveRecord::Migration[5.0]
  def change
    add_column :odds_ares, :responded_to_at, :datetime
  end
end
