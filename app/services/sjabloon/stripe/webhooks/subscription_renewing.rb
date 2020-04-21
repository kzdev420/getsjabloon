module Sjabloon
  module Stripe
    module Webhooks

      class SubscriptionRenewing
        def call(event)
          subscription = Sjabloon::Subscription.find_by(
            processor:    "stripe",
            processor_id: event.data.object.subscription
          )

          notify_owner(subscription.owner, subscription) if subscription.present?
        end

        def notify_owner(owner, subscription)
          if AppConfig.billing["send_emails"]
            Sjabloon::CustomerMailer.subscription_renewing(owner, subscription).deliver_later
          end
        end
      end
    end
  end
end

