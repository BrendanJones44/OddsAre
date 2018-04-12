class CreateChallengeFinalizations < ActiveRecord::Migration[5.0]
  def change
    create_table :challenge_finalizations do |t|
      t.integer :number_guessed

      t.timestamps
    end
  end
end
