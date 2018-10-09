class AddProviderToUsers < ActiveRecord::Migration[5.0]
  def change
    # prevent this migration failing for apps that already have a
    # provider on users
    return if column_exists? :users, :provider

    add_column :users, :provider, :integer
  end
end
