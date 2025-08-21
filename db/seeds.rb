# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# ActiveHashを使用するため、静的データの投入は不要です
# カテゴリー、商品状態、配送料負担、都道府県、発送日数のデータは
# 各ActiveHashモデル内で定義されています
