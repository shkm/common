class AddUninstalledToShops < ActiveRecord::Migration[5.0]
  def change
    add_column :shops, :uninstalled, :boolean, null: false, default: false
  end
end
