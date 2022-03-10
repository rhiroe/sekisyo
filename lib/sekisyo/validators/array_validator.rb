# frozen_string_literal: true

module Sekisyo
  module Validators
    #
    # Sekisyo Validators ArrayValidator is a validator that accepts only array value.
    #
    class ArrayValidator
      def initialize(key, options = {})
        @key = key
        @options = options

        @items_options = @options.fetch('items', {})
        items_validator_class = Sekisyo::Validator::VALIDATORS[@items_options.delete('type')]
        items_validator_class ||= Sekisyo::Validators::AnyValidator
        @items_validator = items_validator_class.new(nil, @items_options)
      end

      attr_reader :key

      def valid?(value)
        type_validate(value) &&
          presence_validate(value) &&
          bytesize_validate(value) &&
          min_size_validate(value) &&
          max_size_validate(value) &&
          items_validate(value)
      end

      private

      def type_validate(value)
        value.is_a? Array
      end

      def presence_validate(value)
        !@options['presence'] || !(value.respond_to?(:empty?) ? !!value.empty? : !value)
      end

      def bytesize_validate(value)
        !@options['max_bytesize'] || value.to_s.bytesize <= @options['max_bytesize'].to_i
      end

      def min_size_validate(value)
        !@options['min_size'] || value.size >= @options['min_size'].to_i
      end

      def max_size_validate(value)
        !@options['max_size'] || value.size <= @options['max_size'].to_i
      end

      def items_validate(value)
        value.all? { |v| @items_validator.valid?(v) }
      end
    end
  end
end
