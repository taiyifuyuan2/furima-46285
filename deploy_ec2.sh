#!/bin/bash

# EC2環境でのRailsアプリデプロイスクリプト
# 使用方法: ./deploy_ec2.sh

set -e  # エラーが発生したら停止

echo "🚀 EC2環境でのRailsアプリデプロイを開始します..."

# 1. パッケージ更新
echo "📦 パッケージを更新中..."
sudo yum update -y

# 2. 必要ツールのインストール
echo "🔧 必要ツールをインストール中..."
sudo yum install -y git gcc make

# 3. Ruby環境のセットアップ
echo "💎 Ruby環境をセットアップ中..."
if [ ! -d "$HOME/.rbenv" ]; then
    echo "rbenvをインストール中..."
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    source ~/.bashrc
    
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    rbenv install 3.2.0
    rbenv global 3.2.0
    gem install bundler
else
    echo "rbenvは既にインストール済みです"
fi

# 4. Node.jsとYarnのインストール
echo "📱 Node.jsとYarnをインストール中..."
if ! command -v node &> /dev/null; then
    curl -sL https://rpm.nodesource.com/setup_18.x | sudo bash -
    sudo yum install -y nodejs
    npm install --global yarn
else
    echo "Node.jsは既にインストール済みです"
fi

# 5. PostgreSQLのインストール
echo "🐘 PostgreSQLをインストール中..."
if ! command -v psql &> /dev/null; then
    sudo amazon-linux-extras enable postgresql15
    sudo yum install -y postgresql postgresql-server postgresql-devel
    
    # DB初期化と起動
    sudo postgresql-setup initdb
    sudo systemctl enable postgresql
    sudo systemctl start postgresql
else
    echo "PostgreSQLは既にインストール済みです"
fi

# 6. PostgreSQLユーザーとDBの作成
echo "👤 PostgreSQLユーザーとDBを作成中..."
if [ ! -f "/tmp/db_setup_done" ]; then
    # postgresユーザーでDB作成
    sudo -u postgres psql << EOF
CREATE USER app_user WITH PASSWORD 'your_secure_password_here';
CREATE DATABASE furima_production OWNER app_user;
CREATE DATABASE furima_46285_development OWNER app_user;
CREATE DATABASE furima_46285_test OWNER app_user;
GRANT ALL PRIVILEGES ON DATABASE furima_production TO app_user;
GRANT ALL PRIVILEGES ON DATABASE furima_46285_development TO app_user;
GRANT ALL PRIVILEGES ON DATABASE furima_46285_test TO app_user;
\q
EOF
    touch /tmp/db_setup_done
    echo "データベースセットアップ完了"
else
    echo "データベースは既にセットアップ済みです"
fi

# 7. アプリケーションの依存関係インストール
echo "📚 アプリケーションの依存関係をインストール中..."
bundle install
yarn install

# 8. データベースのセットアップ
echo "🗄️ データベースをセットアップ中..."
RAILS_ENV=production bundle exec rails db:migrate
RAILS_ENV=production bundle exec rails db:seed

# 9. アセットのプリコンパイル
echo "🎨 アセットをプリコンパイル中..."
RAILS_ENV=production bundle exec rails assets:precompile

# 10. Unicornの起動確認
echo "🦄 Unicornを起動中..."
if pgrep -f "unicorn" > /dev/null; then
    echo "Unicornは既に起動中です"
else
    RAILS_ENV=production bundle exec unicorn -c config/unicorn.rb -E production -D
    echo "Unicornを起動しました"
fi

# 11. Nginxのインストールと設定
echo "🌐 Nginxをセットアップ中..."
if ! command -v nginx &> /dev/null; then
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
    
    sudo systemctl enable nginx
    sudo systemctl start nginx
    echo "Nginxのセットアップ完了"
else
    echo "Nginxは既にインストール済みです"
fi

echo "✅ デプロイが完了しました！"
echo "🌍 ブラウザで http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4) にアクセスしてください"
echo ""
echo "📝 次のステップ:"
echo "1. EC2のセキュリティグループで80番ポートを開放"
echo "2. Elastic IPを割り当て（推奨）"
echo "3. ドメイン名の設定（オプション）"
