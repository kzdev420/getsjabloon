module Sjabloon
  module Stripe
    module StripeSyncEmail
      extend ActiveSupport::Concern

      included do
        after_update :enqeue_sync_email_job,
          if: :should_sync_email_with_processor?
      end

      def should_sync_email_with_processor?
        respond_to? :saved_change_to_email?
      end

      def sync_email_with_processor
        # Update email within Stripe if owner (eg. User) changes it
        send("update_email!")
      end

      private

      def enqeue_sync_email_job
        if processor_id? && !processor_id_changed? && saved_change_to_email?
          Sjabloon::EmailSyncJob.perform_later(id)
        end
      end
    end
  end
end

