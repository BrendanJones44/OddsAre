class AddDeviseTokenAuthToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :provider, :string, null: false, default: "email"
    add_column :users, :uid, :string, null: false, default: ""
    add_column :users, :tokens, :text

    reversible do |direction|
      direction.up do
        User.find_each do |user|
          user.uid = user.email
          user.tokens = nil
          user.save!
        end
      end
    end

    add_index :users, [:uid, :provider], unique: true
  end
end
