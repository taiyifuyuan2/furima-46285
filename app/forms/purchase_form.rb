# frozen_string_literal: true

class PurchaseForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :postal_code, :string
  attribute :prefecture_id, :integer
  attribute :city, :string
  attribute :street_address, :string
  attribute :building_name, :string
  attribute :phone_number, :string
  attribute :token, :string
  attribute :user_id, :integer
  attribute :item_id, :integer

  validates :postal_code, presence: true, format: { with: /\A\d{3}-\d{4}\z/, message: 'は3桁ハイフン4桁で入力してください' }
  validates :prefecture_id, presence: true
  validates :phone_number, presence: true, format: { with: /\A\d{10,11}\z/, message: 'は10桁以上11桁以内の半角数値で入力してください' }

  with_options presence: true do
    validates :city
    validates :street_address
    validates :token
    validates :user_id
    validates :item_id
  end

  validate :prefecture_cannot_be_default

  def initialize(attributes = {})
    super
    @order = nil
    @address = nil
  end

  def save(user, item)
    return false unless valid?

    ActiveRecord::Base.transaction do
      @order = Order.create!(user: user, item: item)
      @address = Address.create!(
        postal_code: postal_code,
        prefecture_id: prefecture_id,
        city: city,
        street_address: street_address,
        building_name: building_name,
        phone_number: phone_number,
        order: @order
      )
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def prefecture_cannot_be_default
    return unless prefecture_id == 1

    errors.add(:prefecture, 'を選択してください')
  end
end
