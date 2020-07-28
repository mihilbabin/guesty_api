# frozen_string_literal: true

module GuestyAPI
  class Accounts < ResourceBase
    def retrieve
      response = @client.get url: '/accounts/me'

      check_response! response

      single_entity response
    end

    private

    def entity_class
      Entities::Account
    end
  end
end
