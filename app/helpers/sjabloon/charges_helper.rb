module Sjabloon::ChargesHelper
  def amount(charge_id)
    charge = Sjabloon::Charge.find(charge_id)

    tag.span number_to_currency(charge.amount.to_f / 100),
      class: charge.amount_refunded? ? "line-through" : nil
  end

  def amount_refunded(charge_id)
    charge = Sjabloon::Charge.find(charge_id)
    return if !charge.amount_refunded?

    "-#{number_to_currency(charge.amount_refunded.to_f / 100)}"
  end
end

