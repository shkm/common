require 'rails_helper'

RSpec.describe Shop, type: :model do
  describe '.with_active_charge' do
    it 'includes only shops with a user whose active charge is true' do
      active_charge_shop = create(:shop, user: build(:user, active_charge: true))
      inactive_charge_shop = create(:shop)

      shops = Shop.with_active_charge
      expect(shops).to include(active_charge_shop)
      expect(shops).not_to include(inactive_charge_shop)
    end
  end

  describe '.with_active_plan' do
    it 'includes only shops whose plan is not cancelled' do
      active_plan_shop = create(:shop)
      cancelled_plan_shop = create(:shop, plan_name: 'cancelled')

      shops = Shop.with_active_plan
      expect(shops).to include active_plan_shop
      expect(shops).not_to include cancelled_plan_shop
    end
  end
end
