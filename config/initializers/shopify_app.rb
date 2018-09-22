ShopifyApp.configure do |config|
  # For non-common, application specific webhooks be sure to do config.webhooks.push() rather than overwriting those here
  # TODO: Check and document what happens when adding/removing webhooks from here for existing shops?
  config.webhooks = [
      { topic: 'app/uninstalled', address: "https://pluginseo.ngrok.io/webhooks/app_uninstalled", format: 'json' },
      { topic: 'shop/update', address: "https://pluginseo.ngrok.io/webhooks/shop_update", format: 'json' },
  ]
  # This would be nice to organise the jobs:
  # config.webhook_jobs_namespace = 'shopify/webhooks'
  # ...however that's only supported in a later ShopifyApp version. Fix is to upgrade all apps to use the latest ShopifyApp and ShopifyAPI
end