# frozen_string_literal: true

module Sekisyo
  #
  # Sekisyo Configuration is a wrapper class that transfers some methods to Hashie::Mash. Available methods are
  #
  # * <tt>deep_merge!</tt>
  # * <tt>method_missing</tt>
  # * <tt>[]</tt>
  # * <tt>[]=</tt>
  #
  class Configuration
    extend Forwardable
    delegate :deep_merge! => :@options,
             :method_missing => :@options,
             :[] => :@options,
             :[]= => :@options

    def initialize
      @options = Hashie::Mash.new
    end
  end
end
