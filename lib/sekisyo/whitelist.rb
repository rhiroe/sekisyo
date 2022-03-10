# frozen_string_literal: true

require_relative 'whitelist_details/path'
require_relative 'whitelist_details/method'
require_relative 'whitelist_details/properties'

module Sekisyo
  #
  # Sekisyo Whitelist parses the yaml file and assists in finding the corresponding whitelist.
  #
  class Whitelist
    #
    # Reads the yaml file containing the whitelist definition and converts it to a Ruby object.
    #
    # @param [Array<string>] file_paths Paths of the yaml file where the whitelist is defined.
    #
    def parse(*file_paths)
      @hash = Hashie::Mash.new.deep_merge(*file_paths.map(&Hashie::Mash.method(:load)))
      @paths = @hash['paths'].map do |path, object|
        Sekisyo::WhitelistDetails::Path.new(path, object)
      end
      self
    end

    #
    # @param [String] path URL string.
    #
    # @return [Sekisyo::WhitelistDetails::Path]
    #
    def find(path)
      @paths.find { |pattern| pattern.match?(path) }
    end
  end
end
