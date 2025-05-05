# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    association :conversation
    association :user
    body { Faker::Lorem.paragraph }

    trait :with_attachment do
      after(:build) do |message|
        message.attachments.attach(
          io: Rails.root.join('spec/fixtures/files/test.pdf').open,
          filename: 'test.pdf',
          content_type: 'application/pdf'
        )
      end
    end
  end
end
