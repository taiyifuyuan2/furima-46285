# frozen_string_literal: true

class ClearItemsData < ActiveRecord::Migration[7.1]
  def up
    # itemsテーブルの全データを削除
    execute 'DELETE FROM items'
  end

  def down
    # ロールバック時は何もしない（削除されたデータは復元できない）
  end
end
