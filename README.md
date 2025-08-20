# FURIMA

## 概要
FURIMAは、フリーマーケットサイトのアプリケーションです。

## 開発環境
- Ruby 3.2.0
- Rails 7.1.5.2
- PostgreSQL

## データベース設計

### テーブル設計

#### users テーブル
| Column | Type | Options |
|--------|------|---------|
| nickname | string | null: false |
| email | string | null: false, unique: true |
| encrypted_password | string | null: false |
| last_name | string | null: false |
| first_name | string | null: false |
| last_name_kana | string | null: false |
| first_name_kana | string | null: false |
| birth_date | date | null: false |

#### items テーブル
| Column | Type | Options |
|--------|------|---------|
| name | string | null: false |
| description | text | null: false |
| category_id | integer | null: false |
| condition_id | integer | null: false |
| shipping_fee_id | integer | null: false |
| prefecture_id | integer | null: false |
| shipping_day_id | integer | null: false |
| price | integer | null: false |
| user | references | null: false, foreign_key: true |

#### orders テーブル
| Column | Type | Options |
|--------|------|---------|
| user | references | null: false, foreign_key: true |
| item | references | null: false, foreign_key: true |

#### addresses テーブル
| Column | Type | Options |
|--------|------|---------|
| postal_code | string | null: false |
| prefecture_id | integer | null: false |
| city | string | null: false |
| street_address | string | null: false |
| building_name | string | |
| phone_number | string | null: false |
| order | references | null: false, foreign_key: true |

### アソシエーション
- User has_many :items
- User has_many :orders
- Item belongs_to :user
- Item has_one :order
- Order belongs_to :user
- Order belongs_to :item
- Order has_one :address
- Address belongs_to :order

