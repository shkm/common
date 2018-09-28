class AddUninstalledToShops < ActiveRecord::Migration
  def change
    add_column :shops, :uninstalled, :boolean, null: false, default: false
  end
end
