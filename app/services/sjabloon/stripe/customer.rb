module Sjabloon
  module Stripe
    module Customer
      def stripe_customer
        if processor_id?
          ::Stripe::Customer.retrieve(processor_id)
        else
          create_customer
        end
      rescue ::Stripe::StripeError => e
        raise StandardError, e.message
      end

      def create_charge(amount, options = {})
        args = {
          amount:      amount,
          currency:    "usd",
          customer:    stripe_customer.id,
          description: customer_name,
        }.merge(options)

        charge = ::Stripe::Charge.create(args)

        Sjabloon::Stripe::Webhooks::ChargeSucceeded.new.create_charge(self, charge)
      rescue ::Stripe::StripeError => e
        raise StandardError, e.message
      end

      def create_subscription!(name, plan, options = {})
        opts         = { plan: plan, trial_from_plan: true }.merge(options)
        sub          = customer.subscriptions.create(opts)
        subscription = create_subscription(sub, "stripe", name, plan)

        subscription
      rescue ::Stripe::StripeError => e
        raise StandardError, e.message
      end

      def update_stripe_card(token)
        customer = stripe_customer
        token    = ::Stripe::Token.retrieve(token)

        return if token.card.id == customer.default_source

        card                    = customer.sources.create(source: token.id)
        customer.default_source = card.id
        customer.save

        update_card_on_file(card)
        true
      rescue ::Stripe::StripeError => e
        raise StandardError, e.message
      end

      def update_email!
        customer             = stripe_customer
        customer.email       = email
        customer.description = customer_name

        customer.save
      end

      def stripe_subscription(subscription_id)
        ::Stripe::Subscription.retrieve(subscription_id)
      end

      def create_invoice!
        return unless processor_id?
        ::Stripe::Invoice.create(customer: processor_id).pay
      end

      def create_upcoming_invoice
        ::Stripe::Invoice.upcoming(customer: processor_id)
      end

      def sync_card_from_stripe
        cust              = stripe_customer
        default_source_id = cust.default_source

        if default_source_id.present?
          card = stripe_customer.sources.data.find{ |s| s.id == default_source_id }

          update(
            card_type:      card.brand,
            card_last4:     card.last4,
            card_exp_month: card.exp_month,
            card_exp_year:  card.exp_year
          )
        else
          update(card_type: nil, card_last4: nil)
        end
      end

      private

      def create_customer
        customer = ::Stripe::Customer.create(
          email:       email,
          source:      card_token,
          description: customer_name
        )

        update(processor: "stripe", processor_id: customer.id)

        source = customer.sources.data.first
        if source.present?
          update_card_on_file customer.sources.retrieve(source.id)
        end

        customer
      end

      def trial_end_date(subscription)
        subscription.trial_end.present? ? Time.at(subscription.trial_end) : nil
      end

      def update_card_on_file(card)
        update!(
          card_type:      card.brand,
          card_last4:     card.last4,
          card_exp_month: card.exp_month,
          card_exp_year:  card.exp_year
        )

        self.card_token = nil
      end
    end
  end
end

