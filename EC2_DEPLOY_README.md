# EC2環境でのRailsアプリデプロイ手順

## 概要
このドキュメントは、Amazon EC2環境でPostgreSQLを使用してRailsアプリをデプロイする手順を説明します。

## 前提条件
- Amazon Linux 2のEC2インスタンス
- セキュリティグループでSSH（22番ポート）が開放済み
- 管理者権限（sudo）を持つユーザー

## 1. EC2インスタンスへの接続

```bash
ssh -i your-key.pem ec2-user@your-ec2-ip
```

## 2. 自動デプロイスクリプトの実行

### 2.1 スクリプトのダウンロード
```bash
# プロジェクトをクローン
git clone https://github.com/taiyifuyuan2/furima-46285.git
cd furima-46285

# スクリプトに実行権限を付与
chmod +x deploy_ec2.sh
```

### 2.2 環境変数の設定
```bash
# .bashrcに環境変数を追加
echo 'export DB_PASSWORD="your_secure_password_here"' >> ~/.bashrc
echo 'export DATABASE_URL="postgresql://app_user:your_secure_password_here@localhost/furima_production"' >> ~/.bashrc
echo 'export RAILS_ENV=production' >> ~/.bashrc
echo 'export SECRET_KEY_BASE="your_secret_key_base_here"' >> ~/.bashrc
echo 'export DEVISE_SECRET_KEY="your_devise_secret_key_here"' >> ~/.bashrc

# 環境変数を読み込み
source ~/.bashrc
```

### 2.3 デプロイスクリプトの実行
```bash
./deploy_ec2.sh
```

## 3. 手動でのセットアップ（スクリプトが失敗した場合）

### 3.1 パッケージ更新
```bash
sudo yum update -y
sudo yum install -y git gcc make
```

### 3.2 Ruby環境のセットアップ
```bash
# rbenvのインストール
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

# ruby-buildのインストール
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Ruby 3.2.0のインストール
rbenv install 3.2.0
rbenv global 3.2.0

# Bundlerのインストール
gem install bundler
```

### 3.3 Node.jsとYarnのインストール
```bash
curl -sL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs
npm install --global yarn
```

### 3.4 PostgreSQLのインストール
```bash
sudo amazon-linux-extras enable postgresql15
sudo yum install -y postgresql postgresql-server postgresql-devel

# データベースの初期化と起動
sudo postgresql-setup initdb
sudo systemctl enable postgresql
sudo systemctl start postgresql
```

### 3.5 データベースユーザーとDBの作成
```bash
# postgresユーザーでログイン
sudo -u postgres psql

# データベースユーザーの作成
CREATE USER app_user WITH PASSWORD 'your_secure_password_here';

# データベースの作成
CREATE DATABASE furima_production OWNER app_user;
CREATE DATABASE furima_46285_development OWNER app_user;
CREATE DATABASE furima_46285_test OWNER app_user;

# 権限の付与
GRANT ALL PRIVILEGES ON DATABASE furima_production TO app_user;
GRANT ALL PRIVILEGES ON DATABASE furima_46285_development TO app_user;
GRANT ALL PRIVILEGES ON DATABASE furima_46285_test TO app_user;

# 終了
\q
```

### 3.6 アプリケーションのセットアップ
```bash
# 依存関係のインストール
bundle install
yarn install

# データベースのセットアップ
RAILS_ENV=production bundle exec rails db:migrate
RAILS_ENV=production bundle exec rails db:seed

# アセットのプリコンパイル
RAILS_ENV=production bundle exec rails assets:precompile
```

### 3.7 Unicornの起動
```bash
RAILS_ENV=production bundle exec unicorn -c config/unicorn.rb -E production -D
```

### 3.8 Nginxのインストールと設定
```bash
sudo amazon-linux-extras enable nginx1
sudo yum install -y nginx

# Nginx設定ファイルの作成
sudo tee /etc/nginx/conf.d/rails.conf > /dev/null << 'EOF'
upstream unicorn {
    server unix:/tmp/unicorn.sock fail_timeout=0;
}

server {
    listen 80;
    server_name _;
    root /home/ec2-user/furima-46285/public;

    location / {
        try_files $uri @unicorn;
    }

    location @unicorn {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_pass http://unicorn;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

# Nginxの起動
sudo systemctl enable nginx
sudo systemctl start nginx
```

## 4. セキュリティ設定

### 4.1 セキュリティグループの設定
- 80番ポート（HTTP）を開放
- 443番ポート（HTTPS）を開放（SSL証明書を使用する場合）

### 4.2 Elastic IPの割り当て
1. EC2コンソールでElastic IPを割り当て
2. インスタンスに関連付け

### 4.3 ファイアウォールの設定
```bash
# 必要に応じてiptablesでファイアウォールを設定
sudo yum install -y iptables-services
sudo systemctl enable iptables
sudo systemctl start iptables
```

## 5. 動作確認

### 5.1 サービスの状態確認
```bash
# PostgreSQL
sudo systemctl status postgresql

# Nginx
sudo systemctl status nginx

# Unicorn（プロセス確認）
ps aux | grep unicorn
```

### 5.2 ログの確認
```bash
# Nginxログ
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# Railsログ
tail -f log/production.log
```

### 5.3 ブラウザでの確認
- `http://your-ec2-ip` にアクセス
- アプリケーションが正常に表示されることを確認

## 6. トラブルシューティング

### 6.1 よくある問題と解決方法

#### PostgreSQL接続エラー
```bash
# PostgreSQLサービスの状態確認
sudo systemctl status postgresql

# 接続テスト
psql -U app_user -d furima_production -h localhost
```

#### Unicorn起動エラー
```bash
# ログの確認
tail -f log/production.log

# プロセスの確認
ps aux | grep unicorn

# 手動起動テスト
RAILS_ENV=production bundle exec unicorn -c config/unicorn.rb -E production
```

#### Nginx設定エラー
```bash
# 設定ファイルの構文チェック
sudo nginx -t

# エラーログの確認
sudo tail -f /var/log/nginx/error.log
```

## 7. メンテナンス

### 7.1 アプリケーションの更新
```bash
# 最新のコードを取得
git pull origin main

# 依存関係の更新
bundle install
yarn install

# データベースの更新
RAILS_ENV=production bundle exec rails db:migrate

# アセットの再コンパイル
RAILS_ENV=production bundle exec rails assets:precompile

# Unicornの再起動
pkill -f unicorn
RAILS_ENV=production bundle exec unicorn -c config/unicorn.rb -E production -D
```

### 7.2 ログローテーション
```bash
# logrotateの設定
sudo tee /etc/logrotate.d/rails > /dev/null << 'EOF'
/home/ec2-user/furima-46285/log/*.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    create 644 ec2-user ec2-user
    postrotate
        pkill -f unicorn
        cd /home/ec2-user/furima-46285
        RAILS_ENV=production bundle exec unicorn -c config/unicorn.rb -E production -D
    endscript
}
EOF
```

## 8. 次のステップ

### 8.1 SSL証明書の設定
- Let's Encryptを使用した無料SSL証明書の取得
- HTTPS対応

### 8.2 監視とアラート
- CloudWatchでのメトリクス監視
- アラートの設定

### 8.3 バックアップ
- データベースの自動バックアップ
- ファイルのバックアップ

### 8.4 スケーリング
- ロードバランサーの設定
- 複数インスタンスでの運用

## 注意事項

- 本番環境では適切なパスワードとシークレットキーを使用してください
- セキュリティグループの設定は必要最小限にしてください
- 定期的なセキュリティアップデートを実施してください
- ログファイルの管理とローテーションを適切に行ってください

## サポート

問題が発生した場合は、以下を確認してください：
1. ログファイルの内容
2. サービスの状態
3. ネットワーク設定
4. セキュリティグループの設定
