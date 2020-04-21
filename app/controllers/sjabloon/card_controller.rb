class Sjabloon::CardController < ApplicationController
  before_action :authenticate_user!, only: [:update]

  def update
    current_payer.update_card(params[:stripeToken])

    redirect_to billing_path, notice: "Successfully updated your card"

  rescue StandardError => e
    redirect_to billing_path, alert: e.message
  end
end

