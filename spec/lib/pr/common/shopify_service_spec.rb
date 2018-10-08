require 'rails_helper'

describe PR::Common::ShopifyService do
  let(:shop) { create(:shop, user: build(:user)) }
  subject(:service) { described_class.new(shop: shop) }

  describe '#determine_price' do
    context 'shop has a plan whose pricing is defined' do
      before { shop.update!(plan_name: 'affiliate') }

      it 'returns the defined price' do
        expected_price = {
          price:      0,
          trial_days: 0,
          plan_name:  'affiliate',
          name:       'Affiliate',
          terms:      'Affiliate terms',
        }

        expect(service.determine_price).to eq expected_price
      end
    end

    context 'shop has no plan whose pricing is defined' do
      before { shop.update!(plan_name: 'foobar') }

      it 'returns the pricing plan without a plan name' do

        expected_price = {
          price:      10.0,
          trial_days: 7,
          name:       'Generic with trial',
          terms:      'Generic terms',
        }

        expect(service.determine_price).to eq expected_price
      end
    end
  end
end
