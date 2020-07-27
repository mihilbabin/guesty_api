# frozen_string_literal: true

module GuestyAPI
  class Accounts < ResourceBase
    def retrieve
      response = @client.get url: '/accounts/me'

      throw!(body: response.body, code: response.code) unless response.success?

      Entities::Account.new(parsed_body(response))
    end
  end
end
