class CreateChallengeResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :challenge_responses do |t|
      t.datetime :read_at
      t.integer :challenge_request_id
      t.integer :response_out_of
      t.integer :response_actor_number

      t.timestamps
    end
  end
end
