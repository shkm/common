class DropApplicationCharges < ActiveRecord::Migration
  def change
    drop_table :application_charges
  end
end
