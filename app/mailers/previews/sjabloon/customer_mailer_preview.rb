module Previews
  class Sjabloon::CustomerMailerPreview < ActionMailer::Preview
    def charge_refunded
      Sjabloon::CustomerMailer.refund(
        AppConfig.billing["payer_class"].constantize.first,
        Sjabloon::Charge.first
      )
    end

    def subscription_renewing
      Sjabloon::CustomerMailer.subscription_renewing(
        AppConfig.billing["payer_class"].constantize.first,
        Sjabloon::Subscription.first
      )
    end

    def charge_succeeded
      Sjabloon::CustomerMailer.receipt(
        AppConfig.billing["payer_class"].constantize.first,
        Sjabloon::Charge.first
      )
    end
  end
end

