const price = () => {
  console.log('price function called');
  
  // 必要な要素を取得
  const priceInput = document.getElementById("item-price");
  const addTaxDom = document.getElementById("add-tax-price");
  const profitDom = document.getElementById("profit");

  console.log('Elements found:', { priceInput, addTaxDom, profitDom });

  // 要素が存在しない場合は処理を終了
  if (!priceInput || !addTaxDom || !profitDom) {
    console.log('Required elements not found');
    return;
  }

  // 価格計算の処理
  const calculatePrice = () => {
    console.log('calculatePrice called');
    const inputValue = priceInput.value;
    const price = parseInt(inputValue) || 0;
    
    console.log('Input value:', inputValue, 'Parsed price:', price);
    
    if (price >= 300 && price <= 9999999) {
      const tax = Math.floor(price * 0.1); // 10%の手数料
      const profit = price - tax;
      
      console.log('Calculated tax:', tax, 'profit:', profit);
      
      addTaxDom.innerHTML = tax.toLocaleString();
      profitDom.innerHTML = profit.toLocaleString();
    } else {
      addTaxDom.innerHTML = "";
      profitDom.innerHTML = "";
    }
  };

  // 入力があるたびにイベント発火
  priceInput.addEventListener("input", calculatePrice);
  console.log('Event listener added for input');

  // ページ読み込み時に既存の価格があれば計算を実行
  if (priceInput.value) {
    console.log('Initial value found, calculating...');
    calculatePrice();
  }
};

// ページ読み込み完了後に実行
console.log('item_price.js loaded, document.readyState:', document.readyState);

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => {
    console.log('DOMContentLoaded event fired for item_price');
    price();
  });
} else {
  console.log('Document already loaded, calling price() immediately');
  price();
}

// さらに確実にするため、少し遅延して実行
setTimeout(() => {
  console.log('Delayed execution of price function');
  price();
}, 100);
