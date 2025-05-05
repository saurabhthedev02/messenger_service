# frozen_string_literal: true

class Conversation < ApplicationRecord
  has_many :conversation_users, dependent: :destroy
  has_many :users, through: :conversation_users, dependent: :destroy
  has_many :messages, dependent: :destroy

  validates :name, presence: true
  validates :is_group, inclusion: { in: [true, false] }

  def unread_messages_count(user)
    query = messages.where.not(user: user)
      .joins(:message_receipts)
      .where(message_receipts: { user: user, read: false })
    query.count
  end
end
