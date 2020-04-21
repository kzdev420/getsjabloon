module Sjabloon::PricingHelper
  def plan_button(plan_id)
    plan = Sjabloon::Plan.find(plan_id)

    link_to button_label,
      button_path(plan.id),
      class: "btn btn--primary block text-center",
      data: {
        target: "sjabloon--plan-switch.button",
        plan_switch_month_id: plan.processor_id,
        plan_switch_year_id: annual_plan_processor_id_for(plan.id)
      }
  end

  private

  def button_label
    user_signed_in? ? signed_in_button_label : "Get started"
  end

  def button_path(plan_id)
    user_signed_in? ? signed_in_button_path(plan_id) : new_user_registration_path
  end


  def signed_in_button_label
    current_payer.subscribed? ? "Go to billing" : "Choose"
  end

  def signed_in_button_path(plan_id)
    plan = Sjabloon::Plan.find(plan_id)

    current_payer.subscribed? ? billing_plans_path : new_billing_path(plan: plan.processor_id)
  end
end

