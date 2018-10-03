class AddReferrerToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :referrer, :string
  end
end
