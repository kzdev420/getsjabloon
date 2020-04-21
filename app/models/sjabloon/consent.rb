module Sjabloon
  class Consent < ApplicationRecord
    self.table_name = "sjabloon_consents"

    belongs_to :user
    belongs_to :policy

    validates :agreed_at, presence: true
  end
end

