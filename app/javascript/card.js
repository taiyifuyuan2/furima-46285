const pay = () => {
  console.log('pay function called');
  
  // PAY.JPライブラリが読み込まれているかチェック
  if (typeof Payjp === 'undefined') {
    console.error('PAY.JP library is not loaded');
    return;
  }
  
  console.log('PAY.JP library loaded successfully');
  
  // PAY.JPの公開鍵が設定されているかチェック
  if (!window.PAYJP_PUBLIC_KEY) {
    console.error('PAYJP_PUBLIC_KEY is not set');
    return;
  }

  console.log('PAYJP_PUBLIC_KEY:', window.PAYJP_PUBLIC_KEY);
  
  try {
    // PAY.JPの正しい使用方法：Payjpコンストラクタを使用
    const payjp = Payjp(window.PAYJP_PUBLIC_KEY);
    console.log('PAY.JP instance created successfully');
    
    const elements = payjp.elements();
    console.log('PAY.JP elements created:', elements);
    
    const numberElement = elements.create('cardNumber');
    const expiryElement = elements.create('cardExpiry');
    const cvcElement = elements.create('cardCvc');
    
    console.log('PAY.JP form elements created:', { numberElement, expiryElement, cvcElement });

    // フォーム要素が存在するかチェック
    const numberForm = document.getElementById("number-form");
    const expiryForm = document.getElementById("expiry-form");
    const cvcForm = document.getElementById("cvc-form");
    
    console.log('DOM elements found:', { numberForm, expiryForm, cvcForm });

    if (numberForm && expiryForm && cvcForm) {
      numberElement.mount('#number-form');
      expiryElement.mount('#expiry-form');
      cvcElement.mount('#cvc-form');
      console.log('PAY.JP elements mounted successfully');
    } else {
      console.error('Form elements not found');
      return;
    }

    const form = document.getElementById("charge-form");
    if (form) {
      form.addEventListener("submit", (e) => {
        e.preventDefault();

        payjp.createToken(numberElement).then(function (response) {
          if (response.error) {
            console.error('Token creation failed:', response.error);
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
    console.error('Error initializing PAY.JP:', error);
  }
};

// ページ読み込み完了後に実行
console.log('card.js loaded, document.readyState:', document.readyState);

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => {
    console.log('DOMContentLoaded event fired');
    pay();
  });
} else {
  console.log('Document already loaded, calling pay() immediately');
  pay();
}