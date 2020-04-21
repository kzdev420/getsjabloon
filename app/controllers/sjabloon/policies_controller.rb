class Sjabloon::PoliciesController < ApplicationController
  def show
    set_policy
  end

  private

  def set_policy
    policy = Sjabloon::Policy.current_policy_for(policy_type)

    if policy.present?
      @policy = policy
    else
      @policy = no_policy_present
    end
  end

  def policy_type
    params[:policy_type]
  end

  def no_policy_present
    Sjabloon::Policy.new(
      title:      "This is a dummy policy (for #{policy_type})",
      content:    "I will need some content too",
      created_at: Time.current
    )
  end
end

