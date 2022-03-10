# frozen_string_literal: true

require_relative '../validator'

module Sekisyo
  module WhitelistDetails
    #
    # Sekisyo WhitelistDetails Path is a definition object for each properties in the whitelist.
    #
    class Properties
      def initialize(properties = {})
        @permit_keys = properties.keys
        @properties = properties.map do |k, v|
          Sekisyo::Validator.new(k, v || {})
        end
      end

      #
      # @param [Hash] params Request parameter.
      #
      # @return [true, false]
      #
      def valid?(params)
        return false unless params.is_a? Hash
        return false unless params == params.slice(*@permit_keys)

        params.all? do |k, v|
          @properties.find { |validator| validator.key == k }&.valid?(v)
        end
      end
    end
  end
end
