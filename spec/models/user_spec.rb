# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_uniqueness_of(:username).allow_nil }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe 'associations' do
    it { should have_many(:conversation_users).dependent(:destroy) }
    it { should have_many(:conversations).through(:conversation_users) }
    it { should have_many(:messages).dependent(:destroy) }
    it { should have_many(:message_receipts).dependent(:destroy) }
    it { should have_one_attached(:avatar) }
  end

  describe 'methods' do
    let(:user) { create(:user) }

    describe '#full_name' do
      context 'when username is present' do
        it 'returns the username' do
          user.username = 'testuser'
          expect(user.full_name).to eq('testuser')
        end
      end

      context 'when username is not present' do
        it 'returns the email prefix' do
          user.username = nil
          expect(user.full_name).to eq(user.email.split('@').first)
        end
      end
    end

    describe '#conversations' do
      let(:conversation) { create(:conversation, :with_users) }
      let!(:conversation_user) { create(:conversation_user, user: user, conversation: conversation) }

      it 'returns all conversations for the user' do
        expect(user.conversations).to include(conversation)
      end
    end
  end
end
