module PR
  module Common
    module Models
      # This is a stake in the ground to gradually move all generic shop code into Common
      # We will work towards this by including this module in our apps and moving generic pieces here
      # So please include PR::Common::Models::Shop
      module Shop
        def self.included(base)

        end
        def determine_price(plan_name)
          # List prices in ascending order in config
          pricing = PR::Common.config.pricing

          best_price = pricing.last

          pricing.each do |price|
            if price[:plan_name] == plan_name
              best_price = price
            end
          end

          return best_price
        end
      end
    end
  end
end

