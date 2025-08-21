# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :category
  belongs_to_active_hash :item_condition
  belongs_to_active_hash :shipping_fee_burden
  belongs_to_active_hash :prefecture
  belongs_to_active_hash :shipping_day

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true,
                    numericality: {
                      only_integer: true,
                      greater_than_or_equal_to: 300,
                      less_than_or_equal_to: 9_999_999
                    }
  validates :image, presence: true

  validate :category_cannot_be_default
  validate :item_condition_cannot_be_default
  validate :shipping_fee_burden_cannot_be_default
  validate :prefecture_cannot_be_default
  validate :shipping_day_cannot_be_default

  private

  def category_cannot_be_default
    return unless category_id == 1

    errors.add(:category, 'を選択してください')
  end

  def item_condition_cannot_be_default
    return unless item_condition_id == 1

    errors.add(:item_condition, 'を選択してください')
  end

  def shipping_fee_burden_cannot_be_default
    return unless shipping_fee_burden_id == 1

    errors.add(:shipping_fee_burden, 'を選択してください')
  end

  def prefecture_cannot_be_default
    return unless prefecture_id == 1

    errors.add(:prefecture, 'を選択してください')
  end

  def shipping_day_cannot_be_default
    return unless shipping_day_id == 1

    errors.add(:shipping_day, 'を選択してください')
  end
end
