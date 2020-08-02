# frozen_string_literal: true

module GuestyAPI
  class Users < ResourceBase
    def list(params: {})
      response = @client.get(
        url: '/users',
        data: params,
      )
      check_response! response

      collection_entity response
    end

    def retrieve(id: :me, fields: nil)
      url = id == :me ? '/me' : "/users/#{id}"
      response = @client.get url: url, data: { fields: fields }

      check_response! response

      single_entity response
    end

    def create(params:)
      response = @client.post url: '/users', data: params

      check_response! response

      single_entity response
    end

    def update(id: :me, params:)
      url = id == :me ? '/me' : "/users/#{id}"
      response = @client.put url: url, data: params

      check_response! response

      single_entity response
    end

    def delete(id:)
      response = @client.delete url: "/users/#{id}"

      check_response! response

      true
    end

    private

    def entity_class
      Entities::User
    end
  end
end
