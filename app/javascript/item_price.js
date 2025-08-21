const price = () => {
  // 必要な要素を取得
  const priceInput = document.getElementById("item-price");
  const addTaxDom = document.getElementById("add-tax-price");
  const profitDom = document.getElementById("profit");

  // 要素が存在しない場合は処理を終了
  if (!priceInput || !addTaxDom || !profitDom) {
    return;
  }

  // 価格計算の処理
  const calculatePrice = () => {
    const inputValue = priceInput.value;
    const price = parseInt(inputValue) || 0;
    
    if (price >= 300 && price <= 9999999) {
      const tax = Math.floor(price * 0.1); // 10%の手数料
      const profit = price - tax;
      
      addTaxDom.innerHTML = tax.toLocaleString();
      profitDom.innerHTML = profit.toLocaleString();
    } else {
      addTaxDom.innerHTML = "";
      profitDom.innerHTML = "";
    }
  };

  // 入力があるたびにイベント発火
  priceInput.addEventListener("input", calculatePrice);

  // ページ読み込み時に既存の価格があれば計算を実行
  if (priceInput.value) {
    calculatePrice();
  }
};

// turbo:loadとturbo:renderイベントを追加
window.addEventListener("turbo:load", price);
window.addEventListener("turbo:render", price);
