require 'rails_helper'

describe PR::Common::ShopifyService do
  let(:shop) { create(:shop, user: build(:user)) }
  subject(:service) { described_class.new(shop: shop) }

  describe '#determine_price' do
    context 'shop has a plan whose pricing is defined' do
      before { shop.update!(plan_name: 'affiliate') }

      it 'returns the defined price' do
        expected_price = PR::Common.config.pricing.detect do |pricing_plan|
          pricing_plan[:plan_name] == 'affiliate'
        end

        expect(service.determine_price).to eq expected_price
      end
    end
  end
end
