require 'rails_helper'

describe PR::Common::WebhookService do
  let(:shop) { create(:shop) }
  let(:uninstalled_shop) { create(:shop, :uninstalled) }
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

  describe '.recreate_webhooks!' do
    it 'creates a new instance for installed shops only' do
      service_shop = described_class.new(shop)

      expect(described_class)
        .to receive(:new)
        .with(shop)
        .and_return service_shop

      expect(described_class)
        .not_to receive(:new)
        .with(uninstalled_shop)

      described_class.recreate_webhooks!
    end
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

    error_classes = [
      ActiveResource::UnauthorizedAccess,
      ActiveResource::ConnectionError,
      Timeout::Error,
      OpenSSL::SSL::SSLError,
      Exception
    ]

    error_classes.each do |error_class|
      context "when a #{error_class} occurs" do
        let(:error) { error_class.new('fail') }

        before do
          allow(ShopifyAPI::Webhook).to receive(:all) { raise error }
        end

        it 'catches the error' do
          expect{ service.recreate_webhooks! }.not_to raise_error
        end

        it 'logs an error' do
          expect(Rails.logger).to receive(:error)

          service.recreate_webhooks!
        end

        it 'returns false' do
          expect(service.recreate_webhooks!).to eq false
        end
      end
    end
  end
end
