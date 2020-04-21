module Sjabloon::ConsentHelper
  def link_to_current_updated_policies_for_them
    policies = current_user.needs_consent_for_mandatory_policies.map { |policy|
      link_to policy.title, policy_path(policy.policy_type)
    }

    policies.to_sentence.html_safe
  end

  def updated_policies_for_them
    policies = current_user.needs_consent_for_mandatory_policies.pluck(:title)

    policies.to_sentence
  end

  def current_mandatory_policies
    ids = Sjabloon::CurrentMandatoryPolicyIdsQuery.new.resolve

    Sjabloon::Policy.where(id: ids)
  end

  def current_terms_available?
    current_mandatory_policies.find_by(policy_type: 'terms').present?
  end

  def current_privacy_policy_available?
    current_mandatory_policies.find_by(policy_type: 'privacy').present?
  end

  def show_cookie_policy_modal
    return if !Sjabloon::Policy.current_policy_for("cookies").present?

    !(user_signed_in? || cookies["_#{Rails.configuration.application_name.parameterize}_accepted_cookie_policy"])
  end

  def validate_consent_to_policies?
    return if !user_signed_in?
    return if %w(policies).include? controller_name

    current_user.needs_consent_for_mandatory_policies?
  end
end

