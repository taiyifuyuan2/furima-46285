
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PurchaseForm, type: :model do
  let(:user) { create(:user) }
  let(:item) { create(:item) }

  describe 'バリデーション' do
    context '正常系' do
      it '有効な属性の場合は有効' do
        purchase_form = build(:purchase_form)
        expect(purchase_form).to be_valid
      end
    end

    context '異常系 - 必須項目のバリデーション' do
      it '必須項目が空の場合は無効' do
        purchase_form = build(:purchase_form, postal_code: '', prefecture_id: '', city: '', street_address: '',
                                              phone_number: '', token: '')
        expect(purchase_form).not_to be_valid
        expect(purchase_form.errors[:postal_code]).to include('は3桁ハイフン4桁で入力してください')
        expect(purchase_form.errors[:prefecture_id]).to include('を選択してください')
        expect(purchase_form.errors[:city]).to include('を入力してください')
        expect(purchase_form.errors[:street_address]).to include('を入力してください')
        expect(purchase_form.errors[:phone_number]).to include('は10桁以上11桁以内の半角数値で入力してください')
        expect(purchase_form.errors[:token]).to include('を入力してください')
      end
    end

    context '異常系 - 郵便番号のフォーマット' do
      it '正しいフォーマットの場合は有効' do
        purchase_form = build(:purchase_form, postal_code: '123-4567')
        expect(purchase_form).to be_valid
      end

      it '不正なフォーマットの場合は無効' do
        purchase_form = build(:purchase_form, postal_code: '1234567')
        expect(purchase_form).not_to be_valid
        expect(purchase_form.errors[:postal_code]).to include('は3桁ハイフン4桁で入力してください')
      end
    end

    context '異常系 - 電話番号のフォーマット' do
      it '10桁の場合は有効' do
        purchase_form = build(:purchase_form, phone_number: '0901234567')
        expect(purchase_form).to be_valid
      end

      it '11桁の場合は有効' do
        purchase_form = build(:purchase_form, phone_number: '09012345678')
        expect(purchase_form).to be_valid
      end

      it '9桁以下の場合は無効' do
        purchase_form = build(:purchase_form, phone_number: '090123456')
        expect(purchase_form).not_to be_valid
        expect(purchase_form.errors[:phone_number]).to include('は10桁以上11桁以内の半角数値で入力してください')
      end

      it '12桁以上の場合は無効' do
        purchase_form = build(:purchase_form, phone_number: '090123456789')
        expect(purchase_form).not_to be_valid
        expect(purchase_form.errors[:phone_number]).to include('は10桁以上11桁以内の半角数値で入力してください')
      end
    end

    context '異常系 - 都道府県の選択' do
      it 'デフォルト値（1）の場合は無効' do
        purchase_form = build(:purchase_form, prefecture_id: 1)
        expect(purchase_form).not_to be_valid
        expect(purchase_form.errors[:prefecture]).to include('を選択してください')
      end

      it '有効な都道府県IDの場合は有効' do
        purchase_form = build(:purchase_form, prefecture_id: 2)
        expect(purchase_form).to be_valid
      end
    end
  end

  describe '#save' do
    context '正常系' do
      it '有効な属性で保存が成功する' do
        purchase_form = build(:purchase_form)
        expect(purchase_form.save(user, item)).to be true
      end

      it '保存成功時にOrderとAddressが作成される' do
        expect do
          purchase_form = build(:purchase_form)
          purchase_form.save(user, item)
        end.to change(Order, :count).by(1).and change(Address, :count).by(1)
      end
    end

    context '異常系' do
      it '無効な属性で保存が失敗する' do
        purchase_form = build(:purchase_form, postal_code: '')
        expect(purchase_form.save(user, item)).to be false
      end
    end
  end
end
