# frozen_string_literal: true

require_relative 'properties'

module Sekisyo
  module WhitelistDetails
    #
    # Sekisyo WhitelistDetails Method is a definition object for each HTTP method of a specific path in the whitelist.
    #
    class Method
      #
      # @param [Hash] object Hash object with array values with :required key and Hash values with :properties key.
      #
      def initialize(object = {})
        @required = object.fetch('required', []).flat_map do |attr|
          attr.is_a?(Hash) ? transform_required_keys(attr) : [[attr]]
        end
        @properties = Sekisyo::WhitelistDetails::Properties.new(object['properties'])
      end

      #
      # @param [Hash] params Request parameters.
      #
      # @return [true, false]
      #
      def valid?(params)
        required_validate(params) && @properties.valid?(params)
      end

      private

      def required_validate(params)
        @required.all? do |keys|
          dig_keys = keys.dup
          key = dig_keys.pop

          if dig_keys.empty?
            params.has_key?(key)
          else
            dig_params = params.dig(*dig_keys)
            dig_params.is_a?(Hash) && dig_params.has_key?(key)
          end
        end
      end

      def transform_required_keys(hash)
        hash.flat_map do |key, values|
          values.map do |value|
            value.is_a?(Hash) ? [key, *transform_required_keys(value)].flatten : [key, value]
          end
        end
      end
    end
  end
end
