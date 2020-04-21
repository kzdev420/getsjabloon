module Sjabloon
  module Stripe
    module Webhooks
      class CustomerDeleted
        def call(event)
          object = event.data.object
          owner  = AppConfig.billing["payer_class"].constantize.find_by(
            processor:    "stripe",
            processor_id: object.id
          )

          return unless owner.present?

          owner.update(
            processor_id:   nil,
            trial_ends_at:  nil,
            card_type:      nil,
            card_last4:     nil,
            card_exp_month: nil,
            card_exp_year:  nil
          )

          owner.subscriptions.update_all(
            trial_ends_at: nil,
            ends_at:       Time.current,
          )
        end
      end
    end
  end
end

