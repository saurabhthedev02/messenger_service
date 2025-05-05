# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validations
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :username, uniqueness: true, allow_nil: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  # Associations
  has_many :conversation_users, dependent: :destroy
  has_many :conversations, through: :conversation_users, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :message_receipts, dependent: :destroy
  has_one_attached :avatar

  # Callbacks
  before_create :set_username_from_email

  # Methods
  def full_name
    username.presence || email.split('@').first
  end

  private

  def set_username_from_email
    # Only set username if it's blank and email is present
    return unless username.blank? && email.present?

    self.username = email.split('@').first
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
