module Sjabloon::Consentable
  extend ActiveSupport::Concern

  included do
    has_many :consents, class_name: "Sjabloon::Consent", dependent: :destroy
  end

  def needs_consent_for_mandatory_policies
    current_mandatory_policy_ids = Sjabloon::CurrentMandatoryPolicyIdsQuery.new.resolve

    policy_ids = current_mandatory_policy_ids - consented_to_policy_ids

    @needs_consent_for_mandatory_policies ||= Sjabloon::Policy.where(id: policy_ids)
  end

  def needs_consent_for_mandatory_policies?
    needs_consent_for_mandatory_policies.any?
  end

  def consented_to_policy_ids
    consents.where.not(agreed_at: nil).pluck(:policy_id)
  end
end

