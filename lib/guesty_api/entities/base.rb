# frozen_string_literal: true

module GuestyAPI
  module Entities
    class Base
      def initialize(payload)
        @raw_data = payload
        @methods = payload.keys.map(&:to_sym)
      end

      def method_missing(method, *_args)
        super unless @methods.include? method
        @raw_data[method.to_s]
      end

      def respond_to_missing?(_method_name, _include_private = false)
        return true if @methods.include? method

        super
      end
    end
  end
end
