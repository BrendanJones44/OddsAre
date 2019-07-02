class AddAuthTokenToUser < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :auth_token, :string
    add_index :users, :auth_token, unique: true
  end

  def down
    remove_column :users, :auth_token, :string
  end
end
