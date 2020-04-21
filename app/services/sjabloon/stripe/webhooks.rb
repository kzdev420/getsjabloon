require "stripe_event"
Dir[File.join(__dir__, "webhooks", "**", "*.rb")].each { |file| require file }

module Sjabloon
  module Stripe
    module Webhooks
      StripeEvent.configure do |events|
        events.subscribe "charge.succeeded",
          Sjabloon::Stripe::Webhooks::ChargeSucceeded.new
        events.subscribe "charge.refunded",
          Sjabloon::Stripe::Webhooks::ChargeRefunded.new

        events.subscribe "invoice.upcoming",
          Sjabloon::Stripe::Webhooks::SubscriptionRenewing.new

        events.subscribe "customer.subscription.created",
          Sjabloon::Stripe::Webhooks::SubscriptionCreated.new
        events.subscribe "customer.subscription.updated",
          Sjabloon::Stripe::Webhooks::SubscriptionUpdated.new
        events.subscribe "customer.subscription.deleted",
          Sjabloon::Stripe::Webhooks::SubscriptionDeleted.new

        events.subscribe "customer.updated",
          Sjabloon::Stripe::Webhooks::CustomerUpdated.new
        events.subscribe "customer.deleted",
          Sjabloon::Stripe::Webhooks::CustomerDeleted.new

        events.subscribe "customer.source.deleted",
          Sjabloon::Stripe::Webhooks::SourceDeleted.new

        events.subscribe "coupon.updated",
          Sjabloon::Stripe::Webhooks::CouponUpdated.new
        events.subscribe "coupon.deleted",
          Sjabloon::Stripe::Webhooks::CouponDeleted.new
      end
    end
  end
end

