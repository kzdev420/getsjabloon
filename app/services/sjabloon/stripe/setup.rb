module Sjabloon
  module Stripe
    module Setup
      include Sjabloon::Stripe::Env
      include Sjabloon::Stripe::Customer
      include Sjabloon::Stripe::Charge
      include Sjabloon::Stripe::Subscription
      include Sjabloon::Stripe::Webhooks
    end
  end
end

