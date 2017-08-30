class CreateChallengeResults < ActiveRecord::Migration[5.0]
  def change
    create_table :challenge_results do |t|
      t.integer :initiator_id
      t.integer :target_id
      t.integer :challenge_out_of
      t.integer :initiator_num
      t.integer :target_num
      t.string :action

      t.timestamps
    end
  end
end
