module Sjabloon
  class Charge < ApplicationRecord
    self.table_name = "sjabloon_charges"

    include Sjabloon::Stripe::Receipt

    belongs_to :owner, class_name: AppConfig.billing["payer_class"], foreign_key: :owner_id

    scope :sorted, -> { order(created_at: :desc) }
    default_scope  -> { sorted }

    validates :amount, presence: true
    validates :processor, presence: true
    validates :processor_id, presence: true
    validates :card_type, presence: true

    def processor_charge
      send("get_charge")
    end

    def refund!(refund_amount = nil)
      refund_amount ||= amount

      send("refund!", refund_amount)
    end

    def charged_to
      "#{card_type} (**** **** **** #{card_last4})"
    end
  end
end

