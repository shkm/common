class AddFieldsFromUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :active_charge, :boolean, default: false
    add_column :users, :shop_id, :integer
  end
end
