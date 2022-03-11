# frozen_string_literal: true

require_relative 'method'

module Sekisyo
  module WhitelistDetails
    #
    # Sekisyo WhitelistDetails Path is a definition object for each path in the whitelist.
    #
    class Path
      VALID_METHODS = {
        GET: 'get',
        POST: 'post',
        PATCH: 'patch',
        PUT: 'put',
        DELETE: 'delete'
      }.freeze

      extend Forwardable
      delegate match?: :@path_pattern

      #
      # @param [String] path Dynamic URL string. Example "/categories/{category_id}/pets/{id}".
      # @param [hash] object Hash object with HTTP method keys.
      #
      # e.g.
      #
      #   object = {
      #              'get' => {
      #                'required' => ['category_id', 'id'],
      #                'properties' => {
      #                  'category_id' => { 'type' => 'integer', 'presence' => true }
      #                  'id' => { 'type' => 'integer', 'presence' => true }
      #                }
      #              },
      #              'post' => { ... }
      #            }
      #
      #
      def initialize(path, object)
        @path = path
        @path_pattern = /^#{path.gsub(/{(.+?)}/, '(?<\\1>[^/]+)')}(\..*)?$/
        @methods = object.slice(*VALID_METHODS.values).transform_values do |value|
          Sekisyo::WhitelistDetails::Method.new(value)
        end
      end

      #
      # Obtain the Path parameter from the dynamic URL according to the definition of the dynamic URL in the whitelist.
      #
      # Example
      #
      #   @path = "/categories/{category_id}/pets/{id}"
      #   url = "/categories/1/pets/2"
      #   path_params(url) #=> { 'category_id' => '1', 'id' => '2' }
      #
      # @param [String] url URL string.
      #
      # @return [Hash] Path parameters.
      #
      def path_params(url)
        param_keys = @path.scan(/(?<=\{).*?(?=\})/)
        @path_pattern =~ url
        param_keys.to_h do |key|
          [key, Regexp.last_match(key)]
        end
      end

      def [](method)
        raise 'Failed to determine HTTP method.' if VALID_METHODS[method.to_sym].nil?

        @methods[VALID_METHODS[method.to_sym]]
      end
    end
  end
end
