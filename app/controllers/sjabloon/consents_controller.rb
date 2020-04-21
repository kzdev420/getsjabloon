class Sjabloon::ConsentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    if Sjabloon::SaveConsentsService.new(current_user, policy_ids).call
      head :ok
    end
  end

  private

  def policy_ids
    params[:policy_ids].split(" ")
  end
end

