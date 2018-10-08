module PR
  module Common
    module Models
      module Shop
        extend ActiveSupport::Concern
        included do
          scope :with_active_plan, -> { where.not(shops: { plan_name: 'cancelled' }) }
          scope :with_active_charge, -> { joins(:user).where(users: { active_charge: true }) }
          scope :installed, -> { where(uninstalled: false) }
        end

        class_methods do
          # add class methods here
        end
      end
    end
  end
end
