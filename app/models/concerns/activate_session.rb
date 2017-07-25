module ActivateSession
  extend ActiveSupport::Concern
  included do
    def activate_session
      if shop
        sess = ShopifyAPI::Session.new(shop.shopify_domain, shop.shopify_token)
        ShopifyAPI::Base.activate_session(sess)
      else
        raise ArgumentError, 'User is not connected to shop'
      end
    end
  end
end
