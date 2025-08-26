// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "controllers"
import "item_price"
import "card"

// Turboを無効化してページ間移動の問題を解決
import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = false