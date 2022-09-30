# frozen_string_literal: true

Rails.application.routes.draw do
  get '/jwt_examples/non_signature', to: 'jwt_examples#non_signature'
  get '/jwt_examples/hmac', to: 'jwt_examples#hmac'
  get '/jwt_examples/rsa', to: 'jwt_examples#rsa'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
