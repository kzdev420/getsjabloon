class ApplicationController < ActionController::Base
  before_action :masquerade_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_payer
    # 'Current' method to refer to for Stripe methods (eg. `.subscription`, etc)
    # Defaults to `current_user`. This is also the class
    # where `include Sjabloon::Stripe` is included (eg. User)
    current_user
  end

  def set_ngrok_urls
    if Ngrok::Tunnel.running?
      # Getting current url
      url = Ngrok::Tunnel.ngrok_url_https

      # Variable hash
      default_url_options = {host: url}

      # Overwriting current variables
      Rails.application.config.action_controller.asset_host = url
      Rails.application.config.action_mailer.asset_host = url
      Rails.application.routes.default_url_options = default_url_options
      Rails.application.config.action_mailer.default_url_options = default_url_options
    end
  end

  helper_method :current_payer

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
