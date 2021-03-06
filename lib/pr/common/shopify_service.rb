module PR
  module Common
    class ShopifyService
      def initialize(shop:)
        @shop = shop
        @user = User.shopify.find_by(shop_id: @shop.id)
      end

      def update_shop(plan_name:, uninstalled:)
        if @shop.plan_name != plan_name && @shop.plan_name == 'affiliate'
          # development shop now on a paid plan
          @user.update(active_charge: false)
          Analytics.track({
                              user_id: @user.id,
                              event: 'Shop Handed off',
                              properties: {
                                  planName: plan_name,
                                  email: @user.email
                              }
                          })
        end
        @shop.update(plan_name: plan_name, uninstalled: uninstalled)
      end

      def set_uninstalled
        Analytics.track({
                            user_id: @user.id,
                            event: 'Uninstalled Shopify app',
                            properties: {
                                activeCharge: @user.has_active_charge?,
                                email: @user.email
                            }
                        })
        @user.update(active_charge: false)
        @shop.update(uninstalled: true)
      end

      def reconcile_with_shopify
        ShopifyAPI::Session.temp(@shop.shopify_domain, @shop.shopify_token) do
          begin
            shopify_shop = ShopifyAPI::Shop.current
            update_shop(plan_name: shopify_shop[:plan_name], uninstalled: false)
          rescue ActiveResource::UnauthorizedAccess => e
            # we no longer have access to the shop- app uninstalled
            set_uninstalled
          rescue ActiveResource::ClientError => e
            if e.response.code == '402'
              # quick and very dirty handling of frozen charges:
              # - we can't set active_charge = false on the user as we're not handling the unfrozen webhook so they'd never get picked up again
            end
          end
        end
        ShopifyAPI::Base.clear_session
      end

      def determine_price(plan_name: @shop.plan_name)
        # List prices in ascending order in config
        pricing = PR::Common.config.pricing

        best_price = pricing.last

        pricing.each do |price|
          if price[:plan_name] == plan_name
            best_price = price
          end
        end

        return best_price
      end
    end
  end
end