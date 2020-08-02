# frozen_string_literal: true

module GuestyAPI
  class GuestInbox < ResourceBase
    def list(params: {})
      response = @client.get url: '/inbox/conversations', data: params

      check_response! response

      collection_entity response
    end

    def retrieve(id:, fields: nil)
      response = @client.get url: "/inbox/conversations/#{id}", data: { fields: fields }

      check_response! response

      single_entity response
    end

    def post(id:, params:)
      response = @client.post url: '/inbox/conversations', data: {
        conversationId: id,
      }.merge(params)

      check_response! response

      single_entity response
    end

    private

    def entity_class
      Entities::GuestConversation
    end
  end
end
