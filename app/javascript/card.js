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
      
      // 各要素の完了状態を監視
      numberElement.on('change', function(event) {
        numberElement._complete = event.complete;
      });
      
      expiryElement.on('change', function(event) {
        expiryElement._complete = event.complete;
      });
      
      cvcElement.on('change', function(event) {
        cvcElement._complete = event.complete;
      });
    } else {
      return;
    }

    const form = document.getElementById("charge-form");
    if (form) {
      form.addEventListener("submit", (e) => {
        e.preventDefault();

        // カード情報が入力されているかチェック
        if (!numberElement._complete || !expiryElement._complete || !cvcElement._complete) {
          // カード情報が不完全な場合は、トークンフィールドを空にしてフォーム送信
          document.getElementById("token-field").value = "";
          form.submit();
          return;
        }

        payjp.createToken(numberElement).then(function (response) {
          if (response.error) {
            // エラーハンドリング
            console.error("PAY.JP Error:", response.error);
            // エラーが発生した場合は、トークンフィールドを空にしてフォーム送信
            document.getElementById("token-field").value = "";
            form.submit();
          } else {
            const token = response.id;
            // 隠しフィールドにトークンを設定
            document.getElementById("token-field").value = token;
            
            numberElement.clear();
            expiryElement.clear();
            cvcElement.clear();
            
            // フォームを送信
            form.submit();
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