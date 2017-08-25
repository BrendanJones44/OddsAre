class CreateFinalizeChallenges < ActiveRecord::Migration[5.0]
  def change
    create_table :finalize_challenges do |t|
      t.integer :challenge_response_id
      t.integer :finalize_actor_number

      t.timestamps
    end
  end
end
