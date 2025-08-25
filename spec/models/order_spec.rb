# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'アソシエーション' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:item) }
    it { is_expected.to have_one(:address) }
  end
end
