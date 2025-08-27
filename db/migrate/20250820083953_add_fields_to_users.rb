# frozen_string_literal: true

class AddFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :nickname, :string, null: false
    add_column :users, :email, :string, null: false
    add_column :users, :encrypted_password, :string, null: false
    add_column :users, :last_name, :string, null: false
    add_column :users, :first_name, :string, null: false
    add_column :users, :last_name_kana, :string, null: false
    add_column :users, :first_name_kana, :string, null: false
    add_column :users, :birth_date, :date, null: false

    add_index :users, :email, unique: true
  end
end


