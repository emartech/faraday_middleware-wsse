require 'faraday'
require 'faraday/middleware'
require 'digest'
require 'time'
require 'base64'

module FaradayMiddleware
  class WSSE < Faraday::Middleware

    def initialize(app, wsse_key, wsse_secret)
      super(app)
      @wsse_key = wsse_key
      @wsse_secret = wsse_secret
    end

    def call(request_env)
      request_env.request_headers['X-WSSE'] = wsse_token

      @app.call(request_env)
    end

    def wsse_token
      nonce = create_nonce
      timestamp = Time.now.utc.iso8601
      password_digest = Base64.encode64(Digest::SHA1.new.hexdigest(nonce + timestamp + @wsse_secret)).strip

      "UsernameToken #{%W(Username="#{@wsse_key}" PasswordDigest="#{password_digest}" Nonce="#{nonce}" Created="#{timestamp}").join ', '}"
    end

    protected

    def create_nonce
      chars = ("a".."z").to_a + ("1".."9").to_a + ("A".."Z").to_a
      nonce = Array.new(20, '').collect { chars[rand(chars.size)] }.join
    end

  end
end
