class Admin::MasqueradesController < Devise::MasqueradesController
  before_action :masquerade_authorize!, only: [:show]

  protected

  def masquerade_authorize!
    redirect_to root_path, notice: "Not authorized" if !current_user.admin?
  end
end
