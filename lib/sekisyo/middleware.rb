# frozen_string_literal: true

module Sekisyo
  #
  # Sekisyo Middleware is rack middleware for input validation.
  #
  class Middleware
    class << self
      #
      # @return [Sekisyo::Configuration] Configuration object, wrapper for Hashie::Mash.
      #
      def configuration
        @configuration ||= Sekisyo::Configuration.new
      end

      #
      # @return [Sekisyo::Whitelist] Whitelist of parameters to be received per request
      #
      def whitelist
        @whitelist ||= Sekisyo::Whitelist.new.parse(*configuration.file_paths)
      end

      #
      # @param [Hash] options Override configuration with this value.
      #
      # ==== Options
      # * <tt>:file_paths</tt>(Array<String>) --- Whitelist yml file paths.
      # * <tt>:undefined_request</tt>(Symbol, nil) --- Specifies what to do with the validation results
      #   if whitelist does not contain a description. Available values are nil(default), :warning, :failure
      # * <tt>:logger</tt>(Logger) --- Specify log class instances.
      # * <tt>:allow_keys</tt>(Array<Symbol, String>) --- Specifies the top-level key
      #   of the parameter to be exempt from validation.
      #
      # ==== Yield
      # * (Sekisyo::Configuration)
      #
      # @return [void]
      #
      def configure(**options)
        if block_given?
          yield configuration
        else
          configuration.deep_merge!(options)
        end
      end

      #
      # @param [Symbol] name Configuration key
      # @param [Any] value Configuration value
      #
      # @return [void]
      #
      def option(name, value = nil)
        configuration[name] = value
      end
    end

    def initialize(app)
      @app = app
      @params = {}
      @configuration = self.class.configuration.dup
      @whitelist = self.class.whitelist.dup
    end

    option :file_paths, ['sekisyo.yml']
    option :undefined_request, nil
    option :logger, Logger.new($stdout)
    option :allow_keys, []

    def call(env)
      return @app.call(env) if valid?(env)

      output_logs(env['PATH_INFO'], @params)

      code   = 400
      body   = ['Bad request']
      header = { 'Content-Type' => 'text/html;charset=utf-8',
                 'Content-Length' => body.sum(&:bytesize).to_s,
                 'X-XSS-Protection' => '1;mode=block',
                 'X-Content-Type-Options' => 'nosniff',
                 'X-Frame-Options' => 'SAMEORIGIN' }
      [code, header, body]
    end

    private

    #
    # ==== Variable
    # * <tt>white_uri</tt>(Sekisyo::WhitelistDetails::Path)
    # * <tt>white_properties</tt>(Sekisyo::WhitelistDetails::Method)
    # * <tt>params</tt>(Hash) --- Integrated request parameters and path parameters.
    #
    # @return [true, false]
    #
    def valid?(env)
      white_uri = @whitelist.find(env['PATH_INFO'])
      white_properties = white_uri&.[](env['REQUEST_METHOD'])
      return undefined_request(env) if white_properties.nil?

      @params = Rack::Request.new(env).params.except(*@configuration['allow_keys'].map(&:to_s))
      @params.merge!(white_uri.path_params(env['PATH_INFO']))
      white_properties.valid?(@params)
    end

    #
    # Processes whether or not to allow a request if there is no whitelist definition for the request.
    #
    # @return [true, false]
    #
    def undefined_request(env)
      case @configuration.undefined_request&.to_sym
      when :warning
        @configuration['logger'].warn "Undefined white list #{env['REQUEST_METHOD']} #{env['PATH_INFO']}"
        true
      when :failure
        false
      else
        true
      end
    end

    def output_logs(path, params)
      @configuration['logger'].info 'Invalid request rejected.'
      @configuration['logger'].info "url: #{path}"
      @configuration['logger'].info "params: #{params}"
    end
  end
end
