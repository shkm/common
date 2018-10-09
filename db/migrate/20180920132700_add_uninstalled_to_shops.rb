class AddUninstalledToShops < ActiveRecord::Migration[5.0]
  def change
    # prevent this migration failing for apps that already have an
    # uninstalled on shops
    return if column_exists? :shops, :uninstalled

    add_column :shops, :uninstalled, :boolean, null: false, default: false
  end
end
