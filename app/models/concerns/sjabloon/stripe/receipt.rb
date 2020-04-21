module Sjabloon
  module Stripe
    module Receipt
      extend ActiveSupport::Concern

      included do
        def filename
          "receipt-#{created_at.strftime('%Y-%m-%d')}.pdf"
        end

        def receipt
          receipt_pdf.render
        end

        def receipt_pdf
          Receipts::Receipt.new(
            id:      processor_id,
            product: AppConfig.billing["product_name"],
            company: {
              name:    AppConfig.billing["business_name"],
              address: AppConfig.billing["business_address"],
              email:   AppConfig.billing["support_email"]
            },

            line_items: line_items
          )
        end

        def line_items
          line_items = [
            ["Date",           created_at.strftime("%d %B %Y")],
            ["Account Billed", "#{owner.name} (#{owner.email})"],
            ["Product",        AppConfig.billing["business_name"]],
            ["Amount",         ActionController::Base.helpers.number_to_currency(amount.to_f / 100)],
            ["Charged to",     "#{card_type} (**** **** **** #{card_last4})"],
            ["Transaction ID", processor_id]
          ]

          line_items
        end
      end
    end
  end
end

