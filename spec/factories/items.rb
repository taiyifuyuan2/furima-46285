# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    price { Faker::Number.between(from: 300, to: 9_999_999) }

    association :user
    category_id { 2 } # レディース
    item_condition_id { 2 } # 新品・未使用
    shipping_fee_burden_id { 2 } # 着払い(購入者負担)
    prefecture_id { 2 }    # 北海道
    shipping_day_id { 2 }  # 1~2日で発送

    after(:build) do |item|
      item.image.attach(io: Rails.root.join('spec/fixtures/files/test_image.png').open,
                        filename: 'test_image.png')
    end
  end
end
