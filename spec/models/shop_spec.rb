require 'rails_helper'

RSpec.describe Shop, type: :model do
  it 'lists active users with active shops' do
    create(:shop, plan_name: 'cancelled', user: create(:user, active_charge: true))
    create(:shop, user: create(:user, active_charge: false))
    shop = create(:shop, plan_name: 'non_cancelled_value', user: create(:user, active_charge: true))
    expect(Shop.active_with_charge.to_a).to eql [shop]
  end
end
