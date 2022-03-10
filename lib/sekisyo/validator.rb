# frozen_string_literal: true

require_relative 'validators/any_validator'
require_relative 'validators/array_validator'
require_relative 'validators/boolean_validator'
require_relative 'validators/file_validator'
require_relative 'validators/float_validator'
require_relative 'validators/integer_validator'
require_relative 'validators/numeric_validator'
require_relative 'validators/object_validator'
require_relative 'validators/string_validator'

module Sekisyo
  #
  # Sekisyo Validator is manages each validator in one place.
  #
  class Validator
    VALIDATORS = {
      'any' => Sekisyo::Validators::AnyValidator,
      'array' => Sekisyo::Validators::ArrayValidator,
      'boolean' => Sekisyo::Validators::BooleanValidator,
      'file' => Sekisyo::Validators::FileValidator,
      'float' => Sekisyo::Validators::FloatValidator,
      'integer' => Sekisyo::Validators::IntegerValidator,
      'numeric' => Sekisyo::Validators::NumericValidator,
      'object' => Sekisyo::Validators::ObjectValidator,
      'string' => Sekisyo::Validators::StringValidator
    }.freeze

    extend Forwardable
    delegate valid?: :@validator, key: :@validator

    def initialize(key, options = {})
      validator_class = VALIDATORS[options.delete('type')]
      validator_class ||= Sekisyo::Validators::AnyValidator
      @validator = validator_class.new(key, options)
    end
  end
end
