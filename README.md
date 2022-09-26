# 目次

<!-- TOC -->

- [目次](#目次)
- [参考記事](#参考記事)
- [概要](#概要)
- [動作コード](#動作コード)
      - [app/controllers/jwt_examples_controller.rb](#appcontrollersjwt_examples_controllerrb)
- [環境構築](#環境構築)
  - [gem の追加](#gem-の追加)
  - [コマンド](#コマンド)
- [エラーなど](#エラーなど)
- [minitest 実行方法](#minitest-実行方法)

<!-- /TOC -->

# 参考記事

- [Ruby で JWT を扱う](https://blog.shimar.me/2017/02/10/ruby-jwt)
- [docker-compose で Rails 6×MySQL の開発環境を構築する方法](https://zenn.dev/tmasuyama1114/articles/4ed199ce0478e7)
- [JWT の概要と Ruby における使い方のメモ](https://qiita.com/sukechannnn/items/0ea1bb4f736ac7108f62)

# 概要

Ruby on Rails 環境で jwt の動作を確認してまとめる

# 動作コード

#### app/controllers/jwt_examples_controller.rb

```rb
require 'jwt'

class JwtExamplesController < ApplicationController
    def non_signature
        # ペイロード指定
        payload = { data: 'test' }

        # JWTエンコード
        token = JWT.encode payload, nil, 'none'

        # JWTデコード
        decoded = JWT.decode token, nil, false

        # デコードした内容
        render json: decoded

        # 返ってくる内容
        # [
        #     {
        #       "data": "test"
        #     },
        #     {
        #       "alg": "none"
        #     }
        # ]
    end

    def hmac
        # ペイロード指定
        payload = { data: 'test' }

        # シークレット
        secret  = 'my_secret'

        # JWTエンコード
        token = JWT.encode payload, secret, 'HS256'

        # JWTデコード
        decoded = JWT.decode token, secret, true, { algorithm: 'HS256' }
        render json: decoded

        # 返ってくる内容
        # [
        #     {
        #       "data": "test"
        #     },
        #     {
        #       "alg": "HS256"
        #     }
        # ]
    end

    def rsa
        # 秘密鍵生成
        rsa_private = OpenSSL::PKey::RSA.generate(2048)

        # 公開鍵生成
        rsa_public = rsa_private.public_key

        # sample data
        payload = {
        id: 1,
        name: 'tanaka',
        password: 'jau0328ura0jrdsf3'
        }

        # payload を暗号化 (秘密鍵でしかできない)
        token = JWT.encode(payload, rsa_private, 'RS256')

        # payload を復号化 (公開鍵でもできる)
        JWT.decode(token, rsa_public, true, { algorithm: 'RS256' })

        # 秘密鍵で復号化
        decoded = JWT.decode(token, rsa_private, true, { algorithm: 'RS256' })
        render json: decoded

        # 返ってくる内容
        # [
        #     {
        #       "id": 1,
        #       "name": "tanaka",
        #       "password": "jau0328ura0jrdsf3"
        #     },
        #     {
        #       "alg": "RS256"
        #     }
        # ]
    end
end

```

# 環境構築

## gem の追加

```rb
gem 'public_suffix', '~> 5.0'
```

を Gemfile に追加。

## コマンド

```sh
git init
touch {Dockerfile,docker-compose.yml,Gemfile,Gemfile.lock,entrypoint.sh,.gitignore,README.md}
docker-compose build
docker-compose run web rails new . --force --no-deps --database=mysql
docker-compose run web rails webpacker:install
docker-compose run web rails db:create
docker-compose run web rails db:migrate
docker-compose up
```

http://localhost:3003 で見られる  
うまくいかなければ参考記事を見る

# エラーなど

- gem の更新時は `docker-compose build` をやり直す
  - https://fuqda.hatenablog.com/entry/2019/03/21/204118

# minitest 実行方法

```sh
docker-compose run web rake test test/controllers/jwt_examples_controller_test.rb
```
