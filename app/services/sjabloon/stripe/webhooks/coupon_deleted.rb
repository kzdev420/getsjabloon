module Sjabloon
  module Stripe
    module Webhooks
      class CouponDeleted
        def call(event)
          object = event.data.object
          coupon = Sjabloon::Coupon.find_by(code: object.id)

          return if coupon.nil?

          coupon.destroy
        end
      end
    end
  end
end


