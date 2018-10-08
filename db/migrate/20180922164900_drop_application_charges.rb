class DropApplicationCharges < ActiveRecord::Migration[5.0]
  def change
    # prevent this migration failing for apps that don't have have an
    # application_charges table
    return unless table_exists? :application_charges

    drop_table :application_charges
  end
end
