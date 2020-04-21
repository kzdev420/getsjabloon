module Sjabloon
  class Coupon < ApplicationRecord
    self.table_name = "sjabloon_coupons"

    scope :is_valid, -> { where(is_valid: true) }
  end
end

