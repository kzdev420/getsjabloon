module Sjabloon::BillingHelper
  def payment_submit_label(plan_id)
    plan = Sjabloon::Plan.find(plan_id)

    plan.has_trial_period? ? "Start your free trial" : "Continue payment"
  end
end

