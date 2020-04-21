module Sjabloon
  module Stripe
    module Webhooks
      class SubscriptionDeleted
        def call(event)
          object       = event.data.object
          subscription = Sjabloon::Subscription.find_by(
            processor:    "stripe",
            processor_id: object.id
          )

          return if subscription.nil?

          subscription.update!(
            ends_at: Time.at(object.ended_at)
          ) if subscription.ends_at.blank? && object.ended_at.present?
        end
      end
    end
  end
end

