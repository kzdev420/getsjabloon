module Sjabloon
  module Stripe
    module Webhooks

      class ChargeRefunded
        def call(event)
          object = event.data.object
          charge = Sjabloon::Charge.find_by(processor: "stripe", processor_id: object.id)

          return unless charge.present?

          charge.update(amount_refunded: object.amount_refunded)
          notify_owner(charge.owner, charge)
        end

        def notify_owner(owner, charge)
          if AppConfig.billing["send_emails"]
            Sjabloon::CustomerMailer.refund(owner, charge).deliver_later
          end
        end
      end
    end
  end
end

