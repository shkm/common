class MakePlanNameNullable < ActiveRecord::Migration[5.2]
  def change
    change_column_null :shops, :plan_name, true
  end
end
