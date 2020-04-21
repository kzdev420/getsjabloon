class Sjabloon::PricingController < ApplicationController
  def show
    @plans = Sjabloon::Plan.
      active.
      visible.
      monthly.
      order(position: :asc, amount: :asc)
  end
end

