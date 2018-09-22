include PR::Common
class ShopUpdateReconcileJob < ApplicationJob
  queue_as :low_priority

  def perform(shop)
    shopify_service = ShopifyService.new(shop: shop)
    shopify_service.reconcile_with_shopify
  end
end