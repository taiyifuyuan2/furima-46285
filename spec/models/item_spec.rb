# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @item = build(:item)
  end

  describe '商品の保存' do
    context '正常系' do
      it '正常な商品情報で保存できる' do
        expect(@item).to be_valid
      end
    end

    context '異常系 - 必須項目のバリデーション' do
      it '商品名が空では保存できない' do
        @item.name = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Name can't be blank")
      end

      it '商品説明が空では保存できない' do
        @item.description = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Description can't be blank")
      end

      it '価格が空では保存できない' do
        @item.price = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Price can't be blank")
      end
    end

    context '異常系 - 価格の範囲・形式バリデーション' do
      it '価格が300未満では保存できない' do
        @item.price = 299
        @item.valid?
        expect(@item.errors.full_messages).to include('Price must be greater than or equal to 300')
      end

      it '価格が9999999を超えると保存できない' do
        @item.price = 10_000_000
        @item.valid?
        expect(@item.errors.full_messages).to include('Price must be less than or equal to 9999999')
      end

      it '価格が整数でないと保存できない' do
        @item.price = 1000.5
        @item.valid?
        expect(@item.errors.full_messages).to include('Price must be an integer')
      end

      it '価格が全角数字では保存できない' do
        @item.price = '１０００'
        @item.valid?
        expect(@item.errors.full_messages).to include('Price is not a number')
      end

      it '価格に文字列が含まれていると保存できない' do
        @item.price = '1000円'
        @item.valid?
        expect(@item.errors.full_messages).to include('Price is not a number')
      end

      it '価格が英数字混合では保存できない' do
        @item.price = '1000abc'
        @item.valid?
        expect(@item.errors.full_messages).to include('Price is not a number')
      end
    end

    context '異常系 - 選択項目のバリデーション' do
      it 'カテゴリーがデフォルト値(---)では保存できない' do
        @item.category_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('Category を選択してください')
      end

      it '商品状態がデフォルト値(---)では保存できない' do
        @item.item_condition_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('Item condition を選択してください')
      end

      it '配送料負担がデフォルト値(---)では保存できない' do
        @item.shipping_fee_burden_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('Shipping fee burden を選択してください')
      end

      it '発送元地域がデフォルト値(---)では保存できない' do
        @item.prefecture_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('Prefecture を選択してください')
      end

      it '発送日数がデフォルト値(---)では保存できない' do
        @item.shipping_day_id = 1
        @item.valid?
        expect(@item.errors.full_messages).to include('Shipping day を選択してください')
      end
    end

    context '異常系 - 関連付けのバリデーション' do
      it 'ユーザーが空では保存できない' do
        @item.user = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('User is required')
      end
    end

    context '異常系 - 画像のバリデーション' do
      it '画像が空では保存できない' do
        @item.image = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Image can't be blank")
      end
    end
  end
end
