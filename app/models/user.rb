class User < ApplicationRecord
  rolify
  ratyrate_rater
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable

  has_many :properties, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_properties, through: :favorites, source: :property
  has_one_attached :avatar
  has_many :messages
  # Messages sent by the user
  has_many :sent_messages, class_name: 'Message', foreign_key: 'user_id', dependent: :destroy
  # Messages received for the user's properties
  has_many :received_messages, through: :properties, source: :messages
  has_many :reviews, dependent: :destroy

  validates :name, presence: true
  validates :phone, format: { with: /\A\+?[\d\s-]+\z/, message: "must be a valid phone number" }, allow_blank: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  after_create :assign_default_role

  # Add scopes for user roles
  scope :buyers, -> { with_role(:buyer) }
  scope :sellers, -> { with_role(:seller) }

  def admin?
    role == 'admin'
  end

  def avatar_thumbnail
    if avatar.attached?
      avatar.variant(resize_to_limit: [100, 100]).processed
    else
      "default_avatar.png"
    end
  end

  def assign_default_role
    if roles.blank?
      if self.role == 'seller'
        add_role(:seller)
        Rails.logger.info "### ASSIGNED SELLER ROLE to #{email} ###"
      else
        add_role(:buyer)
        Rails.logger.info "### ASSIGNED BUYER ROLE to #{email} ###"
      end
    end
  end

  def seller?
    has_role?(:seller)
  end

  def buyer?
    has_role?(:buyer)
  end

  def change_role(new_role)
    return false unless ['buyer', 'seller'].include?(new_role)
    
    transaction do
      roles.destroy_all
      if new_role == 'seller'
        add_role(:seller)
      else
        add_role(:buyer)
      end
    end
    true
  end

  def role
    if seller?
      'seller'
    else
      'buyer'
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["confirmation_sent_at", "confirmation_token", "confirmed_at", "created_at", 
     "current_sign_in_at", "current_sign_in_ip", "email", "encrypted_password", 
     "failed_attempts", "id", "last_sign_in_at", "last_sign_in_ip", "locked_at", 
     "name", "phone", "remember_created_at", "reset_password_sent_at", 
     "reset_password_token", "role_id", "sign_in_count", "unconfirmed_email", 
     "unlock_token", "updated_at", "role"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["avatar_attachment", "avatar_blob", "favorite_properties", "favorites", 
     "messages", "properties", "received_messages", "roles", "sent_messages"]
  end

  # Add ransackable scopes
  def self.ransackable_scopes(auth_object = nil)
    [:buyers, :sellers]
  end
end
