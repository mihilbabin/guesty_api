# frozen_string_literal: true

module GuestyAPI
  class Webhooks < ResourceBase
    def list
      response = @client.get url: '/webhooks'

      check_response! response

      response.parsed_response.map { |payload| entity_class.new payload }
    end

    def retrieve(id:)
      response = @client.get url: "/webhooks/#{id}"

      check_response! response

      single_entity response
    end

    def create(params:)
      response = @client.post url: '/webhooks', data: params

      check_response! response

      single_entity response
    end

    def update(id:, params:)
      response = @client.put url: "/webhooks/#{id}", data: params

      check_response! response

      true
    end

    def delete(id:)
      response = @client.delete url: "/webhooks/#{id}"

      check_response! response

      true
    end

    private

    def entity_class
      Entities::Webhook
    end
  end
end
