class AddProviderToUsers < ActiveRecord::Migration[5.2]
  def change
    return if column_exists? :users, :provider

    add_column :users, :provider, :integer
  end
end
