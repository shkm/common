class AddReferrerToUsers < ActiveRecord::Migration[5.0]
  def change
    # prevent this migration failing for apps that already have a
    # referrer on users
    return if column_exists? :users, :referrer

    add_column :users, :referrer, :string
  end
end
