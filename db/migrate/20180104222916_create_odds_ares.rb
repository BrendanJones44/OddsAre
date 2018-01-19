class CreateOddsAres < ActiveRecord::Migration[5.0]
  def change
    create_table :odds_ares do |t|
      t.integer :initiator_id
      t.integer :recipient_id

      t.timestamps
    end
    add_index :odds_ares, :initiator_id
    add_index :odds_ares, :recipient_id
  end
end
