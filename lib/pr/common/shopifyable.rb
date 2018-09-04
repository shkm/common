module PR
  module Common
    module Shopifyable
      extend ActiveSupport::Concern

      included do
        include ShopifyApp::Shop
        include ShopifyApp::SessionStorage

        scope :active_with_charge, -> { joins('JOIN users ON shops.id = users.shop_id').where(users: { active_charge: true }).where.not(shops: { plan_name: 'cancelled' }) }
      end
    end
  end
end
