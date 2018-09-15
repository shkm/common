class ShopUpdateJob < ApplicationJob
  def perform(params)
    # TODO: Daily job to 'fill in the blanks' for missed webhooks etc.
    shop = Shop.find_by(shopify_domain: params[:shop_domain])



    shop.update(plan_name: params[:webhook]['plan_name'])
  end
end