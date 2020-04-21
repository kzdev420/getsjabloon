class User < ApplicationRecord
  include Sjabloon::Stripe::Payer
  include Sjabloon::Consentable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :masqueradable

  has_person_name

  validates :name, presence: true

  attribute :credits, :integer, default: 0
  attribute :adminrole, :string, default: "no"

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
