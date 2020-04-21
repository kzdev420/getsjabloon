module Sjabloon
  class Subscription < ApplicationRecord
    self.table_name = "sjabloon_subscriptions"

    include Sjabloon::Stripe::Subscription

    belongs_to :owner, class_name: AppConfig.billing["payer_class"], foreign_key: :owner_id
    has_one :plan, primary_key: :processor_plan, foreign_key: :processor_id

    validates :name, presence: true
    validates :processor, presence: true
    validates :processor_id, presence: true
    validates :processor_plan, presence: true
    validates :quantity, presence: true

    scope :on_trial,        ->{ where.not(trial_ends_at: nil).where("? < trial_ends_at", Time.current) }
    scope :cancelled,       ->{ where.not(ends_at: nil) }
    scope :on_grace_period, ->{ cancelled.where("? < ends_at", Time.current) }
    scope :active,          ->{ where(ends_at: nil).or(on_grace_period).or(on_trial) }

    attribute :prorate, :boolean, default: true

    def no_prorate
      self.prorate = false
    end

    def skip_trial
      self.trial_ends_at = nil
    end

    def on_trial?
      trial_ends_at? && Time.current < trial_ends_at
    end

    def cancelled?
      ends_at?
    end

    def on_grace_period?
      cancelled? && Time.current < ends_at
    end

    def active?
      ends_at.nil? || on_grace_period? || on_trial?
    end

    def cancel
      send("cancel_plan")
    end

    def cancel_now!
      send("cancel_plan_now!")
    end

    def resume
      if !on_grace_period?
        raise StandardError,
          "Subscriptions in their grace period can only be resumed"
      end

      send("resume_plan")

      update(ends_at: nil)
      self
    end

    def swap(plan)
      send("swap_plan", plan)
      update(processor_plan: plan, ends_at: nil)
    end

    def processor_subscription
      owner.processor_subscription(processor_id)
    end
  end
end

