# frozen_string_literal: true

module Sekisyo
  module Validators
    #
    # Sekisyo Validators ObjectValidator is a validator that accepts only hash value.
    #
    class ObjectValidator
      extend Forwardable
      delegate :[] => :@properties

      def initialize(key, properties = {})
        @key = key
        @properties = Sekisyo::WhitelistDetails::Properties.new(properties)
      end

      attr_reader :key

      def valid?(value)
        @properties.valid?(value)
      end
    end
  end
end
