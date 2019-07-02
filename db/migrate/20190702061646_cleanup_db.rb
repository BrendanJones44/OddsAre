# There was a re
class CleanupDb < ActiveRecord::Migration[5.0]
  def up
    drop_jwt_blacklist_table_if_exists
    drop_tokens_column_on_users_if_exists
    drop_index_users_on_uid_and_provider_if_exists
  end

  private

  def drop_index_users_on_uid_and_provider_if_exists
    return unless index_exists?(:users, [:uid,:provider])

    remove_index(:users, [:uid,:provider])
  end

  def drop_tokens_column_on_users_if_exists
    return unless column_exists?(:users, :tokens)

    remove_column(:users, :tokens)
  end
  
  def drop_jwt_blacklist_table_if_exists
    return unless ActiveRecord::Base.connection.data_source_exists? 'jwt_blacklist'
    
    drop_table :jwt_blacklist
  end
end
