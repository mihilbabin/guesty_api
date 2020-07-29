# frozen_string_literal: true

require 'oj'

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
      throw!(body: response.body, code: response.code) unless response.success?
    end

    def parsed_body(response)
      Oj.load response.body
    end

    def single_entity(response)
      entity_class.new parsed_body(response)
    end

    def collection_entity(response)
      parsed_body(response)['results'].map { |payload| entity_class.new payload }
    end

    def throw!(body:, code:)
      raise APIError.new(body, code)
    end
  end
end
