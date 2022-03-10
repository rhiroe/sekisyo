# frozen_string_literal: true

module Sekisyo
  module Validators
    #
    # Sekisyo Validators AnyValidator is a validator that can come in any value.
    #
    class AnyValidator
      def initialize(key, options = {})
        @key = key
        @options = options
      end

      attr_reader :key

      def valid?(value)
        presence_validate(value) &&
          bytesize_validate(value)
      end

      private

      def presence_validate(value)
        !@options['presence'] || !(value.respond_to?(:empty?) ? !!value.empty? : !value)
      end

      def bytesize_validate(value)
        !@options['max_bytesize'] || value.to_s.bytesize <= @options['max_bytesize'].to_i
      end
    end
  end
end
