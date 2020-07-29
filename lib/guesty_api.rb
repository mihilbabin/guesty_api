# frozen_string_literal: true

require 'guesty_api/resource_base'
require 'guesty_api/accounts'
require 'guesty_api/client'
require 'guesty_api/entities'
require 'guesty_api/listings'
require 'guesty_api/users'
require 'guesty_api/version'

module GuestyAPI
  class APIError < StandardError
    attr_accessor :code

    def initialize(msg, code)
      super(msg)
      @code = code
    end
  end
end
