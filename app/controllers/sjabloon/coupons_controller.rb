class Sjabloon::CouponsController < ApplicationController
  before_action :set_coupon, only: [:index]

  def index
    if @coupon
      render json: {
        status:             "valid",
        currency:           @coupon.currency,
        amount_off:         @coupon.amount_off,
        percent_off:        @coupon.percent_off,
        duration:           @coupon.duration,
        duration_in_months: @coupon.duration_in_months,
      }
    else
      render json: { status: "not valid" }
    end
  end

  def set_coupon
    return unless code = params[:code]

    code    = code.strip.upcase
    @coupon = Sjabloon::Coupon.where(code: code, is_valid: true).last
  end
end

