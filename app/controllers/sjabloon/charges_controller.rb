class Sjabloon::ChargesController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :redirect_if_not_subscribed, only: [:show], if: :owner_not_subscribed
  before_action :set_charge, only: [:show]

  def show
    respond_to do |format|
      format.pdf {
        send_data @charge.receipt,
          filename: "#{@charge.created_at.strftime("%Y-%m-%d")}-receipt.pdf",
          type: "application/pdf",
          disposition: :inline
      }
    end
  end

  private

  def set_charge
    @charge = current_payer.charges.find_by(processor_id: params[:id])
  end

  def redirect_if_not_subscribed
    redirect_to pricing_path, notice: "You do not have a subscription yet"
  end

  def owner_not_subscribed
    !current_payer.subscribed?
  end
end

