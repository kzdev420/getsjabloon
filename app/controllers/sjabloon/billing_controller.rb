class Sjabloon::BillingController < ApplicationController
  before_action :authenticate_user!, only: [:show, :new, :create, :update, :destroy]
  before_action :redirect_if_not_subscribed, only: [:show, :update, :destroy], if: :owner_not_subscribed
  before_action :set_plan, only: [:new]

  def show
    @plan    = current_payer.subscription.plan
    @charges = current_payer.charges
  end

  def new
    @any_active_coupons_available = Sjabloon::Coupon.is_valid.size > 0
  end

  def create
    owner            = current_payer
    owner.processor  = "stripe"
    owner.card_token = params[:stripeToken]

    owner.subscribe(
      plan:   params[:plan_id],
      coupon: coupon_code
    )


    redirect_to billing_path, notice: "You are successfully subscribed"
  rescue StandardError => e
    redirect_to new_billing_path(plan: params[:plan_id]), alert: e.message
  end

  def update
    current_payer.subscription.resume

    redirect_to billing_path, notice: "Welcome back. You are subscribed again"
  end

  def destroy
    current_payer.subscription.cancel

    redirect_to billing_path, notice: "Cancelled subscription"
  end

  private

  def set_plan
    # check for valid and active plan,
    # if not fallback to first available active plan
    plan = Sjabloon::Plan.active.find_by(processor_id: params[:plan])
    plan.present? ? @plan = plan : @plan = Sjabloon::Plan.active.first
  end

  def redirect_if_not_subscribed
    redirect_to pricing_path, notice: "You do not have a subscription yet"
  end

  def owner_not_subscribed
    !current_payer.subscribed?
  end

  def coupon_code
    return if params[:code].nil?

    params[:code].upcase
  end
end

