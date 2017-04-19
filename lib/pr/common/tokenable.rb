module PR
  module Common
    module Tokenable
      extend ActiveSupport::Concern

      included do
        after_create :update_access_token!

        def update_access_token!
          self.access_token = "#{self.id}:#{Devise.friendly_token}"
          save
        end
      end
    end
  end
end
