# frozen_string_literal: true

require 'yaml'
require 'forwardable'
require 'hashie/mash'
require 'hashie/extensions/parsers/yaml_erb_parser'
require_relative 'sekisyo/version'
require_relative 'sekisyo/configuration'
require_relative 'sekisyo/whitelist'
require_relative 'sekisyo/middleware'

if RUBY_VERSION < '3.0'
  #
  # Define Hash#except and Hash#slice since they do not exist less than Ruby 3.0.
  #
  class Hash
    def except(*keys)
      hash = dup
      keys.each(&method(:delete))
      hash
    end

    def slice(*keys)
      hash = self.class.new
      keys.each { |k| hash[k] = self[k] if has_key?(k) }
      hash
    end
  end
end

module Sekisyo
  class WhitelistDefinitionError < StandardError; end
end
