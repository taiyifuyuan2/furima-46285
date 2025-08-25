# frozen_string_literal: true

FactoryBot.define do
  factory :purchase_form, class: 'PurchaseForm' do
    postal_code { Faker::Address.zip_code }
    prefecture_id { Faker::Number.between(from: 2, to: 47) }
    city { Faker::Address.city }
    street_address { Faker::Address.street_address }
    building_name { Faker::Address.secondary_address }
    phone_number { "0#{Faker::Number.number(digits: 9)}" } # 10桁の日本の電話番号形式
    token { "tok_#{Faker::Alphanumeric.alphanumeric(number: 10)}" }
    user_id { 1 }
    item_id { 1 }
  end
end
