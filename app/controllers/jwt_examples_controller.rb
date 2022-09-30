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
