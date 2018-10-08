module PR
  module Common
    module Models
      # This is a stake in the ground to gradually improve our messy User code
      # As much as possible should be in Common
      # We will work towards this by including this module in our apps and moving generic pieces here
      # So please include PR::Common::Models::User
      module User
        def self.included(base)
          alias_method :has_active_charge?, :active_charge
          alias_method :active_charge?, :active_charge
        end
      end
    end
  end
end
