# frozen_string_literal: true

module Sekisyo
  module Validators
    #
    # Sekisyo Validators IntegerValidator is a validator that accepts only integer value.
    #
    class IntegerValidator
      def initialize(key, options = {})
        @key = key
        @options = options
      end

      attr_reader :key

      def valid?(value)
        type_validate(value) &&
          presence_validate(value) &&
          bytesize_validate(value) &&
          enum_validate(value)
      end

      private

      def type_validate(value)
        /^\d+$/.match?(value.to_s) || value == ''
      end

      def presence_validate(value)
        !@options['presence'] || !(value.respond_to?(:empty?) ? !!value.empty? : !value)
      end

      def bytesize_validate(value)
        !@options['max_bytesize'] || value.to_s.bytesize <= @options['max_bytesize'].to_i
      end

      def enum_validate(value)
        !@options['enum'] || @options['enum'].any? { |e| e.to_s == value.to_s }
      end
    end
  end
end
