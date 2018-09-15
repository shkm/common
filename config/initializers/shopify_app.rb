ShopifyApp.configure do |config|
  # For non-common, application specific webhooks be sure to do config.webhooks.push() rather than overwriting those here
  # TODO: Check and document what happens when adding/removing webhooks from here for existing shops?
  config.webhooks = [
      { topic: 'app/uninstalled', address: "https://pluginseo.ngrok.io/webhooks/app_uninstalled", format: 'json' },
      { topic: 'shop/update', address: "https://pluginseo.ngrok.io/webhooks/shop_update", format: 'json' },
  ]
end