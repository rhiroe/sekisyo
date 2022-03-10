# frozen_string_literal: true

module Sekisyo
  module Validators
    #
    # Sekisyo Validators FileValidator is a validator that accepts only file params value.
    #
    class FileValidator
      FILE_CONTENT_TYPES = %w[
        text/plain
        text/csv
        text/html
        text/css
        text/javascript
        application/octet-stream
        application/json
        application/pdf
        application/vnd.ms-excel
        application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
        application/vnd.ms-powerpoint
        application/vnd.openxmlformats-officedocument.presentationml.presentation
        application/msword
        application/vnd.openxmlformats-officedocument.wordprocessingml.document
        image/jpeg
        image/png
        image/gif
        image/bmp
        image/svg+xml
        application/zip
        application/x-lzh
        application/x-tar
        audio/mpeg
        video/mp4
        video/mpeg
      ].freeze

      def initialize(key, options = {})
        @key = key
        @options = options
      end

      attr_reader :key

      def valid?(value)
        type_validate(value) &&
          presence_validate(value) &&
          file_size_validate(value)
      end

      private

      def type_validate(value)
        return false unless value.is_a? Hash

        allow_file_types = [@options['allow_file_types']].flatten.compact
        content_types = if allow_file_types.empty?
                          FILE_CONTENT_TYPES
                        else
                          FILE_CONTENT_TYPES & allow_file_types
                        end
        content_types.any? { |type| type == value[:type] }
      end

      def presence_validate(value)
        !@options['presence'] || value[:tempfile]&.then { |file| file.size.positive? }
      end

      def file_size_validate(value)
        !@options['max_bytesize'] || value[:tempfile]&.then { |file| file.size <= @options['max_bytesize'].to_i }
      end
    end
  end
end
