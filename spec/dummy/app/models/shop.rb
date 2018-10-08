class Shop < ApplicationRecord
  include PR::Common::Models::Shop

  has_one :user
end
