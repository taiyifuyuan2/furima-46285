import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["price", "addTaxPrice", "profit"]

  connect() {
    this.calculatePrice()
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
