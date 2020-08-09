# frozen_string_literal: true

module GuestyAPI
  module Entities
    class Base
      attr_reader :raw_data

      def initialize(payload)
        @raw_data = payload
        @methods = payload.keys.map(&:to_sym)
      end

      def method_missing(method, *)
        super unless @methods.include? method
        @raw_data[method.to_s]
      end

      def respond_to_missing?(method, *)
        return true if @methods.include? method

        super
      end
    end
  end
end
