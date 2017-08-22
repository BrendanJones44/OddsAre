class CreateChallengeRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :challenge_requests do |t|
      t.integer :recipient_id
      t.integer :actor_id
      t.datetime :read_at
      t.string :action

      t.timestamps
    end
  end
end
