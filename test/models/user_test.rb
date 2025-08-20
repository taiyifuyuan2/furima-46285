# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = build(:user)
  end

  test 'should be valid' do
    assert @user.valid?
  end

  # メールアドレスのバリデーション
  test 'emailが空では登録できない' do
    @user.email = nil
    @user.valid?
    assert_includes @user.errors.full_messages, "Email can't be blank"
  end

  test '重複したemailは登録できない' do
    @user.save
    duplicate_user = build(:user, email: @user.email)
    duplicate_user.valid?
    assert_includes duplicate_user.errors.full_messages, 'Email has already been taken'
  end

  test 'emailに「@」が含まれていないと登録できない' do
    @user.email = 'invalid-email'
    @user.valid?
    assert_includes @user.errors.full_messages, 'Email is invalid'
  end

  # パスワードのバリデーション
  test 'パスワードが空では登録できない' do
    @user.password = nil
    @user.password_confirmation = nil
    @user.valid?
    assert_includes @user.errors.full_messages, "Password can't be blank"
  end

  test 'パスワードが6文字未満では登録できない' do
    @user.password = '12345'
    @user.password_confirmation = '12345'
    @user.valid?
    assert_includes @user.errors.full_messages, 'Password is too short (minimum is 6 characters)'
  end

  test 'パスワードが数字のみでは登録できない' do
    @user.password = '123456'
    @user.password_confirmation = '123456'
    @user.valid?
    assert_includes @user.errors.full_messages, 'Password Include both letters and numbers'
  end

  test 'パスワードに全角文字が含まれていると登録できない' do
    @user.password = 'パスワード123'
    @user.password_confirmation = 'パスワード123'
    @user.valid?
    assert_includes @user.errors.full_messages, 'Password Include both letters and numbers'
  end

  test 'パスワードとパスワード確認が一致していないと登録できない' do
    @user.password_confirmation = 'different123'
    @user.valid?
    assert_includes @user.errors.full_messages, 'Password confirmation doesn\'t match confirmation'
  end

  # ニックネームのバリデーション
  test 'nicknameが空では登録できない' do
    @user.nickname = nil
    @user.valid?
    assert_includes @user.errors.full_messages, "Nickname can't be blank"
  end

  # 姓・名(全角)のバリデーション
  test '姓が空では登録できない' do
    @user.last_name = nil
    @user.valid?
    assert_includes @user.errors.full_messages, "Last name can't be blank"
  end

  test '姓に半角文字が含まれていると登録できない' do
    @user.last_name = 'Tanaka'
    @user.valid?
    assert_includes @user.errors.full_messages, 'Last name Input full-width characters'
  end

  test '名が空では登録できない' do
    @user.first_name = nil
    @user.valid?
    assert_includes @user.errors.full_messages, "First name can't be blank"
  end

  test '名に半角文字が含まれていると登録できない' do
    @user.first_name = 'Taro'
    @user.valid?
    assert_includes @user.errors.full_messages, 'First name Input full-width characters'
  end

  # 姓・名(カナ)のバリデーション
  test '姓カナが空では登録できない' do
    @user.last_name_kana = nil
    @user.valid?
    assert_includes @user.errors.full_messages, "Last name kana can't be blank"
  end

  test '姓カナにカタカナ以外が含まれていると登録できない' do
    @user.last_name_kana = '田中'
    @user.valid?
    assert_includes @user.errors.full_messages, 'Last name kana Input full-width katakana characters'
  end

  test '名カナが空では登録できない' do
    @user.first_name_kana = nil
    @user.valid?
    assert_includes @user.errors.full_messages, "First name kana can't be blank"
  end

  test '名カナにカタカナ以外が含まれていると登録できない' do
    @user.first_name_kana = '太郎'
    @user.valid?
    assert_includes @user.errors.full_messages, 'First name kana Input full-width katakana characters'
  end

  # 生年月日のバリデーション
  test '生年月日が空では登録できない' do
    @user.birth_date = nil
    @user.valid?
    assert_includes @user.errors.full_messages, "Birth date can't be blank"
  end
end
