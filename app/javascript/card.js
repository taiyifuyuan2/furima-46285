const pay = () => {
  // PAY.JPライブラリが読み込まれているかチェック
  if (typeof Payjp === 'undefined') {
    return;
  }
  
  // PAY.JPの公開鍵が設定されているかチェック
  if (!window.PAYJP_PUBLIC_KEY) {
    return;
  }

  try {
    // PAY.JPの正しい使用方法：Payjpコンストラクタを使用
    const payjp = Payjp(window.PAYJP_PUBLIC_KEY);
    
    const elements = payjp.elements();
    
    const numberElement = elements.create('cardNumber');
    const expiryElement = elements.create('cardExpiry');
    const cvcElement = elements.create('cardCvc');

    // フォーム要素が存在するかチェック
    const numberForm = document.getElementById("card-number");
    const expiryForm = document.getElementById("card-expiry");
    const cvcForm = document.getElementById("card-cvc");

    if (numberForm && expiryForm && cvcForm) {
      numberElement.mount('#card-number');
      expiryElement.mount('#card-expiry');
      cvcElement.mount('#card-cvc');
    } else {
      return;
    }

    const form = document.getElementById("charge-form");
    if (form) {
      form.addEventListener("submit", (e) => {
        e.preventDefault();

        payjp.createToken(numberElement).then(function (response) {
          if (response.error) {
            // エラーハンドリング
          } else {
            const token = response.id;
            const renderDom = document.getElementById("charge-form");
            const tokenObj = `<input value=${token} name='purchase_form[token]' type="hidden"> `;
            renderDom.insertAdjacentHTML("beforeend", tokenObj);
            
            numberElement.clear();
            expiryElement.clear();
            cvcElement.clear();
            
            document.getElementById("charge-form").submit();
          }
        });
      });
    }
  } catch (error) {
    // エラーハンドリング
  }
};

// ページ読み込み完了後に実行
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => {
    pay();
  });
} else {
  pay();
}