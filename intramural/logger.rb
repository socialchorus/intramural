module Intramural
  class Logger
    attr_reader :_logger

    def initialize
      @_logger = ::Logger.new(STDOUT)
    end

    delegate :error, :warn, :info, :debug,
      to: :_logger
  end
end
