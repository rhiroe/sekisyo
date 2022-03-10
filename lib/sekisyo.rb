# frozen_string_literal: true

require 'yaml'
require 'hashie/mash'
require 'hashie/extensions/parsers/yaml_erb_parser'
require_relative 'sekisyo/version'
require_relative 'sekisyo/configuration'
require_relative 'sekisyo/whitelist'
require_relative 'sekisyo/middleware'

module Sekisyo
  class WhitelistDefinitionError < StandardError; end
end
