module Sjabloon
  class CurrentMandatoryPolicyIdsQuery
    def initialize()
    end

    def resolve
      policies = []

      available_policy_types.each do |type|
        policies << Sjabloon::Policy.mandatory.current_policy_for(type).try(:id)
      end

      policies.compact
    end

    def available_policy_types
      Sjabloon::Policy::POLICY_TYPES
    end
  end
end

