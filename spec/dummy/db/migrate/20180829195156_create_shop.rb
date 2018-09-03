class CreateShop < ActiveRecord::Migration[5.2]
  def change
    create_table :shops do |t|
      t.string :plan_name
      t.string :shopify_domain
      t.string :shopify_token, null: false
    end
  end
end
