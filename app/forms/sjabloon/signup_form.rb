module Sjabloon
  class SignupForm
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :name, :string
    attribute :email, :string
    attribute :password, :string
    attribute :subscribe_to_newsletter, :boolean, default: false
    attribute :accepted_terms, :boolean
    attribute :accepted_privacy, :boolean

    validates :name, :email, :password, presence: true
    validates :accepted_terms, acceptance: true
    validates :accepted_privacy, acceptance: true

    validate :email_is_unique

    def save!
      ActiveRecord::Base.transaction do
        create_user
        consent_to_policies
        add_to_newsletter
      end if valid?
    end

    def object
      @user
    end

    private

    def create_user
      @user = User.create!(
        name:                  name,
        email:                 email,
        password:              password,
      )

      @user.update! newsletter_subscribed: subscribe_to_newsletter if newsletter_subscribed_exists?
    end

    def add_to_newsletter
      if subscribe_to_newsletter.present? && subscribe_to_newsletter
        Sjabloon::NewsletterSubscribeJob.perform_later @user.id
      end
      true
    end

    def consent_to_policies
      ids = Sjabloon::CurrentMandatoryPolicyIdsQuery.new.resolve

      Sjabloon::SaveConsentsService.new(@user, ids).call
    end

    def newsletter_subscribed_exists?
      User.column_names.include? 'newsletter_subscribed'
    end

    def email_is_unique
      if User.exists? email: email
        errors.add :email, 'has already been taken'
      end
    end
  end
end

