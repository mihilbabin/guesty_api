# frozen_string_literal: true

module GuestyAPI
  class Users < ResourceBase
    # rubocop:disable Naming/MethodParameterName
    def list(q: nil, fields: nil, limit: 20, skip: 0)
      response = @client.get(
        url: '/users',
        data: { q: q, fields: fields, limit: limit, skip: skip },
      )
      check_response! response

      collection_entity response
    end
    # rubocop:enable Naming/MethodParameterName

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
