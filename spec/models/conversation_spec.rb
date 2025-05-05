# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Conversation, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:conversation_users).dependent(:destroy) }
    it { should have_many(:users).through(:conversation_users) }
    it { should have_many(:messages).dependent(:destroy) }
  end

  describe 'methods' do
    let(:conversation) { create(:conversation, :with_users) }
    let(:user) { conversation.users.first }
    let(:other_user) { conversation.users.last }

    describe '#unread_messages_count' do
      context 'in a one-on-one conversation' do
        before do
          # Create a read message from other_user
          read_message = create(:message, conversation: conversation, user: other_user)
          read_message.message_receipts.find_by(user: user).update!(read: true)

          # Create an unread message from other_user
          create(:message, conversation: conversation, user: other_user)
        end

        it 'returns the count of unread messages for a user' do
          expect(conversation.unread_messages_count(user)).to eq(1)
        end
      end

      context 'in a group conversation' do
        let(:group_conversation) { create(:conversation, is_group: true) }
        let(:user) { create(:user) }
        let(:other_user) { create(:user) }
        let(:third_user) { create(:user) }

        before do
          # Add all users to the conversation
          [user, other_user, third_user].each do |u|
            create(:conversation_user, user: u, conversation: group_conversation)
          end

          # Create unread message from other_user
          create(:message, conversation: group_conversation, user: other_user)

          # Create unread message from third_user
          create(:message, conversation: group_conversation, user: third_user)
        end

        it 'returns the count of unread messages from all other users' do
          expect(group_conversation.unread_messages_count(user)).to eq(2)
        end
      end
    end
  end
end
