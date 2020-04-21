class Sjabloon::SignupsController < ApplicationController
  before_action :redirect, only: [:new], if: :user_signed_in?

  layout "devise"

  def new
    @signup = Sjabloon::SignupForm.new
  end

  def create
    @signup = Sjabloon::SignupForm.new(signup_params)

    if @signup.save!
      sign_in @signup.object

      redirect_to authenticated_root_path
    else
      render :new
    end
  end

  private

  def redirect
    redirect_to root_path, notice: "You are already logged in"
  end

  def signup_params
    params.permit(
      :email,
      :name,
      :password,
      :subscribe_to_newsletter,
      :accepted_terms,
      :accepted_privacy,
    )
  end
end

