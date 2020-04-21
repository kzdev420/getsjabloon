module Sjabloon
  class SaveConsentsService
    attr_reader :user, :policy_ids

    def initialize(user, policy_ids)
      @user       = user
      @policy_ids = policy_ids
    end

    def call
      save_consents
    end

    private

    def save_consents
      policies = Sjabloon::Policy.where(id: policy_ids)

      policies.each do |policy|
        create_consent(policy.id)
      end
    end

    def create_consent(policy_id)
      user.consents.create!(
        policy_id: policy_id,
        agreed_at: Time.current
      )
    end
  end
end

