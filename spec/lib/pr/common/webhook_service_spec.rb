require 'rails_helper'

describe PR::Common::WebhookService do
  let(:shop) { create(:shop) }
  let(:existing_webhooks) do
    [
      OpenStruct.new(
        id: 1,
        address: 'https://localhost:3000/webhooks/shop_update',
        topic: 'shop/update',
        created_at: "2018-10-09T08:08:15-04:00",
        updated_at: "2018-10-09T08:08:15-04:00",
        format: 'json',
        fields: [],
        metafield_namespaces: []
      )
    ]
  end
  let(:new_webhooks) do
    [{
      topic: "app/uninstalled",
      address: "https://localhost:3000/webhooks/app_uninstalled",
      format: 'json'
    }]
  end

  subject(:service) { described_class.new(shop) }

  describe '#recreate_webhooks!' do
    before do
      allow(ShopifyApp.configuration).to receive(:webhooks) { new_webhooks }
      allow(ShopifyAPI::Webhook).to receive(:all) { existing_webhooks }
      allow(ShopifyAPI::Webhook).to receive(:delete).with(existing_webhooks.first)
      allow(ShopifyAPI::Webhook).to receive(:create).with(new_webhooks.first)
    end

    it 'requests all existing webhooks' do
      expect(ShopifyAPI::Webhook).to receive(:all)

      service.recreate_webhooks!
    end

    it 'creates new webhooks' do
      expect(ShopifyAPI::Webhook).to receive(:create).with(new_webhooks.first)

      service.recreate_webhooks!
    end

    it 'deletes existing webhooks' do
      expect(ShopifyAPI::Webhook).to receive(:delete).with(existing_webhooks.first.id)

      service.recreate_webhooks!
    end
  end
end

