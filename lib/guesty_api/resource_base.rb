# frozen_string_literal: true

module GuestyAPI
  class ResourceBase
    def initialize(client)
      @client = client
    end

    private

    def parsed_body(response)
      JSON.parse response.body
    end

    def throw!(body:, code:)
      raise APIError.new(body, code)
    end
  end
end
