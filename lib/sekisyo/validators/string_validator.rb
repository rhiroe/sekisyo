# frozen_string_literal: true

module Sekisyo
  module Validators
    #
    # Sekisyo Validators StringValidator is a validator that accepts only string value.
    #
    class StringValidator
      def initialize(key, options = {})
        @key = key
        @options = options
      end

      attr_reader :key

      def valid?(value)
        type_validate(value) &&
          presence_validate(value) &&
          bytesize_validate(value) &&
          enum_validate(value) &&
          match_validate(value)
      end

      private

      def type_validate(value)
        value.is_a? String
      end

      def presence_validate(value)
        !@options['presence'] || !(value.respond_to?(:empty?) ? !!value.empty? : !value)
      end

      def bytesize_validate(value)
        !@options['max_bytesize'] || value.to_s.bytesize <= @options['max_bytesize'].to_i
      end

      def enum_validate(value)
        !@options['enum'] || @options['enum'].any? { |e| e == value }
      end

      def match_validate(value)
        !@options['match'] || /#{@options['match']}/.match?(value)
      end
    end
  end
end
