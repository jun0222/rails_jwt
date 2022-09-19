# 目次

<!-- TOC -->

- [目次](#目次)
- [概要](#概要)
- [参考記事](#参考記事)
- [環境構築](#環境構築)
  - [gem の追加](#gem-の追加)
  - [コマンド](#コマンド)
- [エラーなど](#エラーなど)

<!-- /TOC -->

# 概要

Ruby on Rails 環境で jwt の動作を確認してまとめる

# 参考記事

- [Ruby で JWT を扱う](https://blog.shimar.me/2017/02/10/ruby-jwt)
- [docker-compose で Rails 6×MySQL の開発環境を構築する方法](https://zenn.dev/tmasuyama1114/articles/4ed199ce0478e7)

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
docker-compose up
```

http://localhost:3003 で見られる  
うまくいかなければ参考記事を見る

# エラーなど

- gem の更新時は `docker-compose build` をやり直す
  - https://fuqda.hatenablog.com/entry/2019/03/21/204118
