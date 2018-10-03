class AddPlanNameToShops < ActiveRecord::Migration[5.0]
  def change
    # prevent this migration failing for apps that already have a
    # plan_name on shops
    return if column_exists? :shops, :plan_name

    add_column :shops, :plan_name, :string
  end
end
