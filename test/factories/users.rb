# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
    nickname { 'テストユーザー' }
    last_name { '田中' }
    first_name { '太郎' }
    last_name_kana { 'タナカ' }
    first_name_kana { 'タロウ' }
    birth_date { Date.new(1990, 1, 1) }
  end
end
