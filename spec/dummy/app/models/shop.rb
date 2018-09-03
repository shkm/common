class Shop < ActiveRecord::Base
  include PR::Common::Shopifyable
  has_one :user
end
