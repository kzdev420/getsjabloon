class Sjabloon::PlansController < ApplicationController
  before_action :redirect_if_not_subscribed, only: [:index, :update], if: :owner_not_subscribed
  before_action :authenticate_user!, only: [:index, :update]

  def index
    @plans        = Sjabloon::Plan.active.visible.order(position: :asc, amount: :asc)
    @subscription = current_payer.subscription
    @plan         = @subscription.plan
  end

  def update
    plan = Sjabloon::Plan.find_by!(processor_id: params[:id])

    current_payer.subscription.swap(plan.processor_id)

    redirect_to billing_plans_path, notice: "Your plan has changed"

  rescue StandardError => e
    redirect_to billing_plans_path, alert: e.message
  end

  private

  def redirect_if_not_subscribed
    redirect_to pricing_path, notice: "You do not have a subscription yet"
  end

  def owner_not_subscribed
    !current_payer.subscribed?
  end
end

