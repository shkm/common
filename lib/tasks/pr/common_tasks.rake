namespace 'common' do
  namespace 'webhooks' do
    desc "Recreate all webhooks based on config. Optionally pass a comma-separated list of domains."
    task :recreate, [:shops] => [:environment] do
      shops = args[:shops].blank? &&
              Shop.all ||
              Shop.where(shopify_domain: args[:shops].split(',').map(&:strip))

      shops.each do |shop|
        PR::Common::WebhookService.new(shop).recreate_webhooks!
      end
    end
  end
end
