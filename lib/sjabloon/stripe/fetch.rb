require "./app/services/sjabloon/stripe/env.rb"
module Sjabloon
  module Stripe
    module Plans
      include Sjabloon::Stripe::Env

      def self.fetch!
        remote_plans = ::Stripe::Plan.list

        remote_plans.each do |processor_plan|
          plan = Sjabloon::Plan.where(
            processor_id: processor_plan.id
          ).first_or_create

          plan.update(
            amount:            processor_plan.amount,
            currency:          processor_plan.currency,
            nickname:          processor_plan.nickname,
            trial_period_days: processor_plan.trial_period_days,
            interval:          processor_plan.interval,
            interval_count:    processor_plan.interval_count,
            product:           processor_plan.product,
            active:            processor_plan.active,
            visible:           processor_plan.active == true ? plan.visible : false
          )

          p "✅ #{processor_plan.nickname} (#{processor_plan.id})"
        end
      end
    end

    module Coupons
      include Sjabloon::Stripe::Env

      def self.fetch!
        remote_coupons = ::Stripe::Coupon.list

        remote_coupons.each do |processor_coupon|
          coupon = Sjabloon::Coupon.where(
            code: processor_coupon.id
          ).first_or_create

          coupon.update(
            name:               processor_coupon.name,
            currency:           processor_coupon.currency,
            amount_off:         processor_coupon.amount_off,
            percent_off:        processor_coupon.percent_off,
            max_redemptions:    processor_coupon.max_redemptions,
            duration:           processor_coupon.duration,
            duration_in_months: processor_coupon.duration_in_months,
            redeem_by:          processor_coupon.redeem_by,
            times_redeemed:     processor_coupon.times_redeemed,
            is_valid:           processor_coupon.valid
          )

          p "✅ #{coupon.name} (#{coupon.code})"
        end
      end
    end
  end
end

