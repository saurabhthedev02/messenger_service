# frozen_string_literal: true

FactoryBot.define do
  factory :message_receipt do
    association :message
    association :user
    read { false }
  end
end
