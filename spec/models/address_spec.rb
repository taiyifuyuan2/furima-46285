# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'アソシエーション' do
    it { is_expected.to belong_to(:order) }
  end

  describe 'バリデーション' do
    it { is_expected.to validate_presence_of(:postal_code) }
    it { is_expected.to validate_presence_of(:prefecture_id) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:street_address) }
    it { is_expected.to validate_presence_of(:phone_number) }

    describe '郵便番号のフォーマット' do
      it '正しいフォーマットの場合は有効' do
        address = build(:address, postal_code: '123-4567')
        expect(address).to be_valid
      end

      it '不正なフォーマットの場合は無効' do
        address = build(:address, postal_code: '1234567')
        expect(address).not_to be_valid
        expect(address.errors[:postal_code]).to include('は3桁ハイフン4桁で入力してください')
      end
    end

    describe '電話番号のフォーマット' do
      it '10桁の場合は有効' do
        address = build(:address, phone_number: '0901234567')
        expect(address).to be_valid
      end

      it '11桁の場合は有効' do
        address = build(:address, phone_number: '09012345678')
        expect(address).to be_valid
      end

      it '9桁以下の場合は無効' do
        address = build(:address, phone_number: '090123456')
        expect(address).not_to be_valid
        expect(address.errors[:phone_number]).to include('は10桁以上11桁以内の半角数値で入力してください')
      end

      it '12桁以上の場合は無効' do
        address = build(:address, phone_number: '090123456789')
        expect(address).not_to be_valid
        expect(address.errors[:phone_number]).to include('は10桁以上11桁以内の半角数値で入力してください')
      end
    end

    describe '都道府県の選択' do
      it 'デフォルト値（1）の場合は無効' do
        address = build(:address, prefecture_id: 1)
        expect(address).not_to be_valid
        expect(address.errors[:prefecture]).to include('を選択してください')
      end

      it '有効な都道府県IDの場合は有効' do
        address = build(:address, prefecture_id: 2)
        expect(address).to be_valid
      end
    end
  end
end
