# frozen_string_literal: true

require 'jwt'

class JwtExamplesController < ApplicationController
  def non_signature
    # ペイロード指定
    payload = { data: 'test' }

    # JWTエンコード
    token = JWT.encode payload, nil, 'none'

    # JWTデコード
    decoded = JWT.decode token, nil, false

    # 変数の内容をresponse
    render json: { payload: payload, token: token, decoded: decoded }

    # 返ってくる内容
    # {
    #     "payload": {
    #       "data": "test"
    #     },
    #     "token": "eyJhbGciOiJub25lIn0.eyJkYXRhIjoidGVzdCJ9.",
    #     "decoded": [
    #       {
    #         "data": "test"
    #       },
    #       {
    #         "alg": "none"
    #       }
    #     ]
    # }
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

    # 変数の内容をresponse
    render json: { payload: payload, secret: secret, token: token, decoded: decoded }

    # 返ってくる内容
    # {
    #   "payload": {
    #     "data": 'test'
    #   },
    #   "secret": 'my_secret',
    #   "token": 'eyJhbGciOiJIUzI1NiJ9.eyJkYXRhIjoidGVzdCJ9.xsOz46FXT2XOQdlbjGFU0YVgeygBw3cr8lhLJReh0v0',
    #   "decoded": [
    #     {
    #       "data": 'test'
    #     },
    #     {
    #       "alg": 'HS256'
    #     }
    #   ]
    # }
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
    decoded_public = JWT.decode(token, rsa_public, true, { algorithm: 'RS256' })

    # 秘密鍵で復号化
    decoded_secret = JWT.decode(token, rsa_private, true, { algorithm: 'RS256' })

    # 変数の内容をresponse
    render json: { rsa_private: rsa_private, rsa_public: rsa_public, payload: payload, token: token,
                   decoded_public: decoded_public, decoded_secret: decoded_secret }

    # 返ってくる内容
    # {
    #   "rsa_private": {

    #   },
    #   "rsa_public": {

    #   },
    #   "payload": {
    #     "id": 1,
    #     "name": 'tanaka',
    #     "password": 'jau0328ura0jrdsf3'
    #   },
    #   "token": 'eyJhbGciOiJSUzI1NiJ9.eyJpZCI6MSwibmFtZSI6InRhbmFrYSIsInBhc3N3b3JkIjoiamF1MDMyOHVyYTBqcmRzZjMifQ.r6LwB967AIL5IL62IM9YVf_sFXxd6rl-M5dg7VDyWeSwvFJAS5t8g-5oh2sOpkindlk3C6YC4KDjUXsvk5rZwlk8yP5xVEOBXouHHN5kpSG7dwk0-F46MYCebEFjuIjwwidZU5GkGHP5LP5wGIQYcVLg9vx7bX_VBghlURpaGh0Wca7RmcSZ6ocf1_9oyIBv9q2sXT9uRHkzj1pSZS-KcsQgHTenqaK2nYOICa2cU_ZI8VO--jIIZBY4xEcSEAvZToL-f7amc8HGmWgMUZLSEcmhQlm8qREfeOmE9wgFlthoWPZ-wH9zNqZuluTp8i8d5nW2ecO6NfzpBwNp9ZK2Tg',
    #   "decoded_public": [
    #     {
    #       "id": 1,
    #       "name": 'tanaka',
    #       "password": 'jau0328ura0jrdsf3'
    #     },
    #     {
    #       "alg": 'RS256'
    #     }
    #   ],
    #   "decoded_secret": [
    #     {
    #       "id": 1,
    #       "name": 'tanaka',
    #       "password": 'jau0328ura0jrdsf3'
    #     },
    #     {
    #       "alg": 'RS256'
    #     }
    #   ]
    # }
  end
end
