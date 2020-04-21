module Sjabloon
  class CustomerMailer < ApplicationMailer
    def receipt(customer, charge)
      @customer, @charge = customer, charge

      if charge.respond_to? :receipt
        attachments[charge.filename] = charge.receipt
      end

      mail(
        to:      to(customer),
        subject: subjects["receipt_subject"]
      )
    end

    def refund(customer, charge)
      @customer, @charge = customer, charge

      mail(
        to:      to(customer),
        subject: subjects["receipt_subject"]
      )
    end

    def subscription_renewing(customer, subscription)
      mail(
        to:      to(customer),
        subject: subjects["renewing_subject"]
      )
    end

    private

    def to(customer)
      if customer.respond_to?(:name)
        "#{customer.name} <#{customer.email}>"
      else
        customer.email
      end
    end

    def subjects
      AppConfig.billing["emails"]
    end
  end
end

