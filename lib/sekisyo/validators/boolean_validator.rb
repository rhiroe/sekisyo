# frozen_string_literal: true

module Sekisyo
  module Validators
    #
    # Sekisyo Validators BooleanValidator is a validator that accepts only boolean value.
    #
    class BooleanValidator
      def initialize(key, options = {})
        @key = key
        @options = options
      end

      attr_reader :key

      def valid?(value)
        type_validate(value) &&
          presence_validate(value)
      end

      private

      def type_validate(value)
        ['true', 'false', ''].include?(value)
      end

      def presence_validate(value)
        !@options['presence'] || !(value.respond_to?(:empty?) ? !!value.empty? : !value)
      end
    end
  end
end
