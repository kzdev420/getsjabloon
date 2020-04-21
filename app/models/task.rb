class Task < ApplicationRecord
	attribute :credits, :integer, default: 1
	attribute :status, :string, default: "Pending of payment"
end
