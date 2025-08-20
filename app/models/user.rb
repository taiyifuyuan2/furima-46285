# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # カスタムフィールドのバリデーション
  validates :nickname, presence: true
  validates :last_name, presence: true
  validates :last_name, format: { with: /\A[ぁ-んァ-ヶー-龥々]+\z/, message: 'Input full-width characters' },
                        if: :last_name_present?
  validates :first_name, presence: true
  validates :first_name, format: { with: /\A[ぁ-んァ-ヶー-龥々]+\z/, message: 'Input full-width characters' },
                         if: :first_name_present?
  validates :last_name_kana, presence: true
  validates :last_name_kana, format: { with: /\A[ァ-ヶー]+\z/, message: 'Input full-width katakana characters' },
                             if: :last_name_kana_present?
  validates :first_name_kana, presence: true
  validates :first_name_kana, format: { with: /\A[ァ-ヶー]+\z/, message: 'Input full-width katakana characters' },
                              if: :first_name_kana_present?
  validates :birth_date, presence: true

  # パスワードのバリデーション
  validates :password, presence: true
  validates :password, format: { with: /\A(?=.*[a-zA-Z])(?=.*\d)/, message: 'Include both letters and numbers' },
                       if: :password_required?
  validates :password, format: { with: /\A[!-~]+\z/, message: 'Cannot contain full-width characters' },
                       if: :password_required?

  private

  def password_required?
    !persisted? || password.present? || password_confirmation.present?
  end

  def last_name_present?
    last_name.present?
  end

  def first_name_present?
    first_name.present?
  end

  def last_name_kana_present?
    last_name_kana.present?
  end

  def first_name_kana_present?
    first_name_kana.present?
  end
end
