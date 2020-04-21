module Sjabloon::PlansHelper
  def annual_plan_for(plan_id)
    plan        = Sjabloon::Plan.find(plan_id)
    annual_plan = Sjabloon::Plan.active.visible.where(product: plan.product).annual.last
  end

  def annual_amount_for(plan_id)
    return if annual_plan_for(plan_id).nil?

    annual_plan_for(plan_id).amount
  end

  def annual_price_for(plan_id)
    return if annual_plan_for(plan_id).nil?

    annual_plan_for(plan_id).price
  end

  def annual_plan_processor_id_for(plan_id)
    return if annual_plan_for(plan_id).nil?

    annual_plan_for(plan_id).processor_id
  end

  def plan_item(key, value)
    case value
    when Integer
      "#{value} #{key.pluralize(key).humanize}"
    when String
      key.humanize
    when true
      "#{key.humanize} included"
    when false
      "#{key.humanize} not included"
    end
  end

  def change_plan_button(owner, plan_id)
    plan       = Sjabloon::Plan.find(plan_id)
    owner_plan = owner.subscription.plan if owner.subscribed?

    if owner_plan == plan
      tag.span "Current plan", class: "text-gray-500"
    elsif owner_plan.amount > plan.amount
      link_to "Downgrade",
        billing_plan_path(plan.processor_id),
        method: :patch,
        data: {
          confirm: "Are you sure? Your subscription will be changed immediately"
        }
    elsif owner_plan.amount < plan.amount
      link_to "Upgrade",
        billing_plan_path(plan.processor_id),
        method: :patch,
        data: {
          confirm: "Are you sure? Your subscription will be changed immediately"
        }
    end
  end
end

