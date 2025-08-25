# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :order
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

  validates :postal_code, presence: true, format: { with: /\A\d{3}-\d{4}\z/, message: 'は3桁ハイフン4桁で入力してください' }
  validates :prefecture_id, presence: true
  validates :city, presence: true
  validates :street_address, presence: true
  validates :phone_number, presence: true, format: { with: /\A\d{10,11}\z/, message: 'は10桁以上11桁以内の半角数値で入力してください' }

  validate :prefecture_cannot_be_default

  private

  def prefecture_cannot_be_default
    return unless prefecture_id == 1

    errors.add(:prefecture, 'を選択してください')
  end
end
