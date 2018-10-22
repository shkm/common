require 'rails_helper'

describe 'Webhooks' do
  include ActiveJob::TestHelper

  describe 'POST webhooks/customers_redact' do
  end

  describe 'POST webhooks/shop_redact' do
  end

  describe 'POST webooks/customers_data_request' do
    def send_request
      data = { type: 'customers_data_request' }

      post '/webhooks/customers_data_request',
        params: data.to_json,
        headers: {
          'Content-Type' => 'application/json',
          'X-Shopify-Topic' => 'customers/data_request',
          'X-Shopify-Hmac-Sha256' => generate_hmac(data.to_json)
        }
    end

    it 'sends out an e-mail with webhook content' do
      perform_enqueued_jobs do
        expect(ActionMailer::Base.deliveries.count).to eq 0

        send_request

        expect(ActionMailer::Base.deliveries.count).to eq 1

        mail = ActionMailer::Base.deliveries.last
        expect(mail.subject).to eq 'Customer Data Request'
        expect(mail.from).to eq [Settings.support_email]
        expect(mail.to).to eq [Settings.support_email]
        expect(mail.body.to_s).to include({
          'topic' => 'customers_data_request',
          'webhook' => {
            'type' => 'customers_data_request'
          }
        }.inspect)
      end
    end
  end
end

