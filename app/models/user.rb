class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable,
         :omniauthable, omniauth_providers: [:google_oauth2, :github]

  has_many :properties, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_properties, through: :favorites, source: :property
  has_one_attached :avatar
  has_many :messages
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id', dependent: :destroy

  validates :name, presence: true
  validates :phone, format: { with: /\A\+?[\d\s-]+\z/, message: "must be a valid phone number" }, allow_blank: true

  def admin?
    role == 'admin'
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.avatar_url = auth.info.image
    end
  end

  def avatar_thumbnail
    if avatar.attached?
      avatar.variant(resize_to_limit: [100, 100]).processed
    else
      "default_avatar.png"
    end
  end
end
