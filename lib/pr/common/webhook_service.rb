module PR
  module Common
    class WebhookService
      # Recreates all webhooks and returns a list of any that failed
      def self.recreate_webhooks!(shops = Shop.installed)
        shops.find_each.map do |shop|
          new(shop).recreate_webhooks! || shop.shopify_domain
        end.compact
      end

      def initialize(shop)
        @shop = shop
      end

      def recreate_webhooks!
        wrap_errors do
          with_shop do
            Rails.logger.info "Recreating webhooks for #{@shop.shopify_domain}"

            # If anything fails due to shop not being installed,
            # I would expect it to happen here.
            existing_webhooks = fetch_existing

            # ensure that any new webhooks are installed first.
            # that way, if something goes wrong, at least we haven't removed
            # anything.
            install_from_config

            destroy(existing_webhooks)
          end
        end
      end

      private

      def fetch_existing
        ShopifyAPI::Webhook.all
      end

      def install_from_config
        ShopifyApp.configuration.webhooks.each(&(ShopifyAPI::Webhook.method(:create)))
      end

      def destroy(webhooks)
        Array.wrap(webhooks).each { |webhook| ShopifyAPI::Webhook.delete(webhook.id) }
      end

      def with_shop
        ShopifyAPI::Session.temp(@shop.shopify_domain, @shop.shopify_token) do
          return yield
        end
      end

      # We don't want things to explode if something goes wrong, but we do want to
      # notify.
      def wrap_errors
        yield
      rescue ActiveResource::UnauthorizedAccess => e
        # This probably means the shop is no longer installed.
        Rails.logger.error "Failed to modify webhooks for #{@shop.shopify_domain}. "\
          "Unauthorized: Consider checking if it's still installed, and uninstalling if not. Error: "\
          "#{e.message}"

        false
      rescue ActiveResource::ConnectionError => e
        Rails.logger.error "Failed to modify webhooks for #{@shop.shopify_domain}. "\
          "Some kind of connection error occurred. Error: "\
          "#{e.message}"

        false
      rescue Timeout::Error => e
        Rails.logger.error "Failed to modify webhooks for #{@shop.shopify_domain}. "\
          "Connection timed out. Error: #{e.message}"

        false
      rescue OpenSSL::SSL::SSLError => e
        Rails.logger.error "Failed to modify webhooks for #{@shop.shopify_domain}. "\
          "SSLError. Error: #{e.message}"

        false
      rescue Exception => e
        Rails.logger.error "Failed to modify webhooks for #{@shop.shopify_domain}. "\
          "This shouldn't have happened. Error: #{e.message}"

        false
      end
    end
  end
end
