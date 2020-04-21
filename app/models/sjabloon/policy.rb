module Sjabloon
  class Policy < ApplicationRecord
    self.table_name = "sjabloon_policies"

    POLICY_TYPES = %w(terms privacy cookies)

    has_many :consents, class_name: "Sjabloon::Consent"
    has_many :users, through: :consents

    validates :title, :content, presence: true
    validates :policy_type, inclusion: { in: POLICY_TYPES }

    scope :mandatory, -> { where(mandatory: true) }

    def self.current_policy_for(policy_type)
      where(policy_type: policy_type).
      order(created_at: :desc).
      first
    end
  end
end

