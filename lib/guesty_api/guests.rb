# frozen_string_literal: true

module GuestyAPI
  class Guests < ResourceBase
    def list(params: {})
      response = @client.get(
        url: '/guests',
        data: params,
      )
      check_response! response

      collection_entity response
    end

    def retrieve(id:, fields: nil)
      response = @client.get url: "/guests/#{id}", data: { fields: fields }

      check_response! response

      single_entity response
    end

    def create(params:)
      response = @client.post url: '/guests', data: params

      check_response! response

      single_entity response
    end

    def update(id:, params:)
      response = @client.put url: "/guests/#{id}", data: params

      check_response! response

      single_entity response
    end

    def delete(id:)
      response = @client.delete url: "/guests/#{id}"

      check_response! response

      true
    end

    private

    def entity_class
      Entities::Guest
    end
  end
end
