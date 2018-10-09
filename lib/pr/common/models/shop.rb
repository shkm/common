require 'shopify_app/shop'
require 'shopify_app/session_storage'
module PR
  module Common
    module Models
      module Shop
        extend ActiveSupport::Concern

        include ::ShopifyApp::Shop
        include ::ShopifyApp::SessionStorage

        included do
          scope :with_active_plan, -> { where('"shops"."plan_name" NOT IN (\'cancelled\', \'frozen\')') }
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
