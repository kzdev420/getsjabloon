module Sjabloon
  module Stripe
    module Charge
      def get_charge
        ::Stripe::Charge.retrieve(processor_id)
      rescue ::Stripe::StripeError => e
        raise StandardError, e.message
      end

      def refund!(amount_to_refund)
        ::Stripe::Refund.create(
          charge: processor_id,
          amount: amount_to_refund
        )

        update(amount_refunded: amount_to_refund)
      rescue ::Stripe::StripeError => e
        raise StandardError, e.message
      end
    end
  end
end

