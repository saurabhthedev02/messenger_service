# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }

    trait :with_avatar do
      after(:build) do |user|
        user.avatar.attach(
          io: Rails.root.join('spec/fixtures/files/avatar.jpg').open,
          filename: 'avatar.jpg',
          content_type: 'image/jpeg'
        )
      end
    end
  end
end
