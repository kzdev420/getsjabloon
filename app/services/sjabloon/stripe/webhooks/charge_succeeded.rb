module Sjabloon
  module Stripe
    module Webhooks
      class ChargeSucceeded
        def call(event)
          object = event.data.object

          owner = AppConfig.billing["payer_class"].constantize.find_by(
            processor:    :stripe,
            processor_id: object.customer
          )

          return unless owner.present?
          return if owner.charges.where(processor_id: object.id).any?

          charge = create_charge(owner, object)
          notify_owner(owner, charge)
          charge
        end

        def create_charge(owner, object)
          charge = owner.charges.find_or_initialize_by(
            processor:    "stripe",
            processor_id: object.id,
          )

          charge.update(
            amount:         object.amount,
            card_last4:     object.source.last4,
            card_type:      object.source.brand,
            card_exp_month: object.source.exp_month,
            card_exp_year:  object.source.exp_year,
            created_at:     Time.at(object.created)
          )

          charge
        end

        def notify_owner(owner, charge)
          if AppConfig.billing["send_emails"]
            Sjabloon::CustomerMailer.receipt(owner, charge).deliver_later
          end
        end
      end
    end
  end
end

