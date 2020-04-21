module Sjabloon
  class EmailSyncJob < ApplicationJob
    queue_as :default

    def perform(id)
      owner = AppConfig.billing["payer_class"].constantize.find(id)

      owner.sync_email_with_processor
    rescue ActiveRecord::RecordNotFound
      Rails.logger.info "Couldn't find this owner with the id: #{id}"
    end
  end
end

