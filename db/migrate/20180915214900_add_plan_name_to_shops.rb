class AddPlanNameToShops < ActiveRecord::Migration
  def change
    add_column :shops, :plan_name, :string
  end
end
