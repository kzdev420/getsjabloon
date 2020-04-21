module Sjabloon
  module Stripe
    module Payer
      extend ActiveSupport::Concern

      included do
        include Sjabloon::Stripe::Setup
        include Sjabloon::Stripe::StripeSyncEmail

        has_many :charges, class_name: "Sjabloon::Charge", foreign_key: :owner_id, inverse_of: :owner
        has_many :subscriptions, class_name: "Sjabloon::Subscription", foreign_key: :owner_id, inverse_of: :owner

        attribute :plan, :string
        attribute :quantity, :integer
        attribute :card_token, :string
      end

      def customer
        raise StandardError, "Email is required to create a customer" if email.nil?

        customer = send("stripe_customer")

        update_card(card_token) if card_token.present?

        customer
      end

      def customer_name
        [try(:first_name), try(:last_name)].compact.join(" ")
      end

      def charge(amount_in_cents, options = {})
        send("create_charge", amount_in_cents, options)
      end

      def subscribe(name: "default", plan: "default", **options)
        send("create_subscription!", name, plan, options)
      end

      def update_card(token)
        customer if processor_id.nil?

        send("update_stripe_card", token)
      end

      def on_trial?(name: "default", plan: nil)
        return true if default_generic_trial?(name, plan)

        subscription = subscription(name: name)
        return subscription && subscription.on_trial? if plan.nil?

        subscription && subscription.on_trial? && subscription.processor_plan == plan
      end

      def on_generic_trial?
        trial_ends_at? && trial_ends_at > Time.zone.now
      end

      def processor_subscription(subscription_id)
        send("stripe_subscription", subscription_id)
      end

      def subscribed?(name: "default", processor_plan: nil)
        subscription = subscription(name: name)

        return false if subscription.nil?
        return subscription.active? if processor_plan.nil?

        subscription.active? && subscription.processor_plan == processor_plan
      end

      def subscription(name: "default")
        subscriptions.where(name: name).last
      end

      def invoice!
        send("create_invoice!")
      end

      def upcoming_invoice
        send("creat_upcoming_invoice")
      end

      private

      def create_subscription(subscription, processor, name, plan, quantity = 1)
        subscriptions.create!(
          name:           name || "default",
          processor:      processor,
          processor_id:   subscription.id,
          processor_plan: plan,
          trial_ends_at:  send("trial_end_date", subscription),
          quantity:       quantity,
          ends_at:        nil
        )
      end

      def default_generic_trial?(name, plan)
        plan.nil? &&
          name == "default" &&
          on_generic_trial?
      end
    end
  end
end

