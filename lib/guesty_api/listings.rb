# frozen_string_literal: true

module GuestyAPI
  class Listings < ResourceBase
    def list(params: {})
      response = @client.get url: '/listings', data: params

      check_response! response

      collection_entity response
    end

    def retrieve(id:, fields: nil)
      response = @client.get url: "/listings/#{id}", data: { fields: fields }

      check_response! response

      single_entity response
    end

    def create(params:)
      response = @client.post url: '/listings', data: params

      check_response! response

      single_entity response
    end

    def update(id:, params:)
      response = @client.put url: "/listings/#{id}", data: params

      check_response! response

      single_entity response
    end

    private

    def entity_class
      Entities::Listing
    end
  end
end
