class WebhooksController < ShopifyApp::WebhooksController
  def receive
    # Backwards-compatible uninstalled webhook at /webhooks/.
    # Can be removed later.
    if webhook_type.blank? && request.headers['HTTP_X_SHOPIFY_TOPIC'] == 'app/uninstalled'
        params[:type] = 'app_uninstalled'
    end

    super
  end
end
