# frozen_string_literal: true

module GuestyAPI
  class Reservations < ResourceBase
    def list(params: {})
      response = @client.get url: '/reservations', data: params

      check_response! response

      collection_entity response
    end

    def retrieve(id:, fields: nil)
      response = @client.get url: "/reservations/#{id}", data: { fields: fields }

      check_response! response

      single_entity response
    end

    def create(params:)
      response = @client.post url: '/reservations', data: params

      check_response! response

      single_entity response
    end

    def update(id:, params:)
      response = @client.put url: "/reservations/#{id}", data: params

      check_response! response

      single_entity response
    end

    private

    def entity_class
      Entities::Reservation
    end
  end
end
