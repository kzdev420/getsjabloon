module Sjabloon
  module Stripe
    module Webhooks
      class CouponUpdated
        def call(event)
          object = event.data.object
          coupon = Sjabloon::Coupon.find_by(code: object.id)

          return if coupon.nil?

          coupon.is_valid       = object.valid
          coupon.times_redeemed = object.times_redeemed
          coupon.name           = object.name

          coupon.save!
        end
      end
    end
  end
end

