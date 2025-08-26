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

  validates :token, presence: { message: "can't be blank" }
  validates :postal_code, presence: { message: "can't be blank" },
                          format: { with: /\A\d{3}-\d{4}\z/, message: 'is invalid. Enter it as follows (e.g. 123-4567)' }
  validates :prefecture_id, presence: { message: "can't be blank" }
  validates :city, presence: { message: "can't be blank" }
  validates :street_address, presence: { message: "can't be blank" }
  validates :phone_number, presence: { message: "can't be blank" }

  validate :phone_number_format_and_length

  # フィールド名を英語に設定
  def self.human_attribute_name(attribute, options = {})
    case attribute.to_s
    when 'postal_code'
      'Postal code'
    when 'prefecture_id'
      'Prefecture'
    when 'city'
      'City'
    when 'street_address'
      'Addresses'
    when 'phone_number'
      'Phone number'
    when 'token'
      'Token'
    else
      super
    end
  end

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

    errors.add(:prefecture, "can't be blank")
  end

  def phone_number_format_and_length
    # 電話番号が空の場合も「is too short」と「is invalid」を表示
    if phone_number.blank?
      errors.add(:phone_number, 'is too short')
      errors.add(:phone_number, 'is invalid. Input only number')
      return
    end

    # 電話番号が数字のみで構成されているかチェック（空でない場合のみ）
    unless phone_number.match?(/\A\d+\z/)
      errors.add(:phone_number, 'is invalid. Input only number')
      return
    end

    # 電話番号が10桁未満の場合
    errors.add(:phone_number, 'is too short') if phone_number.length < 10

    # 電話番号が11桁を超える場合
    return unless phone_number.length > 11

    errors.add(:phone_number, 'is too long')
  end
end
