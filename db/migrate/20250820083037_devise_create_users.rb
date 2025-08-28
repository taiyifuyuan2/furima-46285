# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: "", limit: 191
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token, limit: 191
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token, limit: 191
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false
      # t.string   :unlock_token, limit: 191
      # t.datetime :locked_at

      t.timestamps null: false
    end

    # インデックス（長さ 191 を指定）
    add_index :users, :email,                unique: true, length: 191
    add_index :users, :reset_password_token, unique: true, length: 191
    # add_index :users, :confirmation_token,  unique: true, length: 191   # 使うなら
    # add_index :users, :unlock_token,        unique: true, length: 191   # 使うなら
  end
end


# 適当なコメントを追加
# テスト用の変更
# コミット用の文字列
# 最終更新完了
# 強制コミット実行
