# frozen_string_literal: true

module GuestyAPI
  class Client
    include HTTParty
    base_uri 'https://api.guesty.com/api/v2'

    def initialize(username:, password: nil, auth_mode: :basic)
      @username = username
      @password = password
      @auth_mode = auth_mode
    end

    def get(url:, data: nil)
      self.class.get(url, query: data, **auth)
    end

    def post(url:, data:)
      self.class.post(url, body: data, **auth)
    end

    def put(url:, data:)
      self.class.put(url, body: data, **auth)
    end

    def delete(url:)
      self.class.delete(url, **auth)
    end

    private

    def auth
      if @auth_mode == :basic
        { basic_auth: { username: @username, password: @password } }
      else
        { headers: { 'Authorization' => "Bearer #{@username}" } }
      end
    end
  end
end
