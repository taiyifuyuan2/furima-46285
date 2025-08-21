import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["price", "addTaxPrice", "profit"]

  connect() {
    // ページ読み込み時に価格フィールドの値を確認し、値がある場合は計算を実行
    if (this.priceTarget.value) {
      this.calculatePrice()
    }
  }

  calculatePrice() {
    const price = parseInt(this.priceTarget.value) || 0
    
    if (price >= 300 && price <= 9999999) {
      const tax = Math.floor(price * 0.1) // 10%の手数料
      const profit = price - tax
      
      this.addTaxPriceTarget.textContent = tax.toLocaleString()
      this.profitTarget.textContent = profit.toLocaleString()
    } else {
      this.addTaxPriceTarget.textContent = ""
      this.profitTarget.textContent = ""
    }
  }
}
