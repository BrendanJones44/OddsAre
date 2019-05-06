class AddAuthUuidToUsers < ActiveRecord::Migration[5.0]
  def change
    #add_column :users, :auth_uuid, :uuid, default: "gen_random_uuid()", null: false
  end
end
