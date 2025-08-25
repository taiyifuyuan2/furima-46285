# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    nickname              { Faker::Name.initials(number: 2) }
    email                 { Faker::Internet.email }
    password              { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
    last_name            { Faker::Name.last_name }
    first_name           { Faker::Name.first_name }
    last_name_kana       { 'タナカ' }
    first_name_kana      { 'タロウ' }
    birth_date           { Faker::Date.birthday(min_age: 18, max_age: 65) }
  end
end
