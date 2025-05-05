# frozen_string_literal: true

FactoryBot.define do
  factory :conversation do
    name { Faker::Lorem.sentence }
    is_group { false }

    trait :with_users do
      after(:create) do |conversation|
        # Create exactly two users for the conversation
        user1 = create(:user)
        user2 = create(:user)
        create(:conversation_user, user: user1, conversation: conversation)
        create(:conversation_user, user: user2, conversation: conversation)
      end
    end

    trait :with_messages do
      after(:create) do |conversation|
        user = conversation.users.first
        create_list(:message, 3, conversation: conversation, user: user)
      end
    end
  end
end
