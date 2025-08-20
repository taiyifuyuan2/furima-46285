# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      email: 'test@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      nickname: 'テストユーザー',
      last_name: '田中',
      first_name: '太郎',
      last_name_kana: 'タナカ',
      first_name_kana: 'タロウ',
      birth_date: Date.new(1990, 1, 1)
    )
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'nickname should be present' do
    @user.nickname = nil
    assert_not @user.valid?
  end

  test 'last_name should be present' do
    @user.last_name = nil
    assert_not @user.valid?
  end

  test 'first_name should be present' do
    @user.first_name = nil
    assert_not @user.valid?
  end

  test 'last_name_kana should be present' do
    @user.last_name_kana = nil
    assert_not @user.valid?
  end

  test 'first_name_kana should be present' do
    @user.first_name_kana = nil
    assert_not @user.valid?
  end

  test 'birth_date should be present' do
    @user.birth_date = nil
    assert_not @user.valid?
  end

  test 'password should include both letters and numbers' do
    @user.password = 'password'
    @user.password_confirmation = 'password'
    assert_not @user.valid?
  end
end
