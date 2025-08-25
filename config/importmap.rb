# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'item_price', to: 'item_price.js'
pin 'card', to: 'card.js'
pin 'rails-ujs', to: 'https://ga.jspm.io/npm:rails-ujs@6.1.7/lib/assets/compiled/rails-ujs.js'
