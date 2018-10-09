class MakePlanNameNotNullable < ActiveRecord::Migration[5.0]
  def change
    change_column_null :shops, :plan_name, false
  end
end
