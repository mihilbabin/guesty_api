# frozen_string_literal: true

module GuestyAPI
  class ResourceBase
    def initialize(client)
      @client = client
    end

    private

    def entity_class
      raise StandardError, '`:entity_class method` should be overriden in a subclass'
    end

    def check_response!(response)
      parsed = response.parsed_response
      msg = parsed.is_a?(Hash) ? parsed['message'] : parsed

      throw!(msg: msg, code: response.code) unless response.success?
    end

    def single_entity(response)
      entity_class.new response.parsed_response
    end

    def collection_entity(response)
      response.parsed_response['results'].map { |payload| entity_class.new payload }
    end

    def throw!(msg:, code:)
      raise APIError.new(msg, code)
    end
  end
end
