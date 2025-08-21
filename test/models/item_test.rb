# frozen_string_literal: true

require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  def setup
    @item = build(:item)
  end

  # 正常系テスト
  test '正常な商品情報で保存できる' do
    assert @item.valid?
  end

  # 商品名のバリデーション
  test '商品名が空では保存できない' do
    @item.name = nil
    @item.valid?
    assert_includes @item.errors.full_messages, "Name can't be blank"
  end

  # 商品説明のバリデーション
  test '商品説明が空では保存できない' do
    @item.description = nil
    @item.valid?
    assert_includes @item.errors.full_messages, "Description can't be blank"
  end

  # 価格のバリデーション
  test '価格が空では保存できない' do
    @item.price = nil
    @item.valid?
    assert_includes @item.errors.full_messages, "Price can't be blank"
  end

  test '価格が300未満では保存できない' do
    @item.price = 299
    @item.valid?
    assert_includes @item.errors.full_messages, 'Price must be greater than or equal to 300'
  end

  test '価格が9999999を超えると保存できない' do
    @item.price = 10_000_000
    @item.valid?
    assert_includes @item.errors.full_messages, 'Price must be less than or equal to 9999999'
  end

  test '価格が整数でないと保存できない' do
    @item.price = 1000.5
    @item.valid?
    assert_includes @item.errors.full_messages, 'Price must be an integer'
  end

  # カテゴリーのバリデーション
  test 'カテゴリーがデフォルト値(---)では保存できない' do
    @item.category_id = 1
    @item.valid?
    assert_includes @item.errors.full_messages, 'Category を選択してください'
  end

  # 商品状態のバリデーション
  test '商品状態がデフォルト値(---)では保存できない' do
    @item.item_condition_id = 1
    @item.valid?
    assert_includes @item.errors.full_messages, 'Item condition を選択してください'
  end

  # 配送料負担のバリデーション
  test '配送料負担がデフォルト値(---)では保存できない' do
    @item.shipping_fee_burden_id = 1
    @item.valid?
    assert_includes @item.errors.full_messages, 'Shipping fee burden を選択してください'
  end

  # 発送元地域のバリデーション
  test '発送元地域がデフォルト値(---)では保存できない' do
    @item.prefecture_id = 1
    @item.valid?
    assert_includes @item.errors.full_messages, 'Prefecture を選択してください'
  end

  # 発送日数のバリデーション
  test '発送日数がデフォルト値(---)では保存できない' do
    @item.shipping_day_id = 1
    @item.valid?
    assert_includes @item.errors.full_messages, 'Shipping day を選択してください'
  end

  # ユーザーのバリデーション
  test 'ユーザーが空では保存できない' do
    @item.user = nil
    @item.valid?
    assert_includes @item.errors.full_messages, 'User is required'
  end

  # 画像のバリデーション
  test '画像が空では保存できない' do
    @item.image = nil
    @item.valid?
    assert_includes @item.errors.full_messages, "Image can't be blank"
  end
end
