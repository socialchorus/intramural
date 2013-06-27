module Intramural
  class Decoder
    attr_reader :message

    def initialize(message, logger)
      @message = message
    end

    def perform
      JSON.parse(message)
    rescue JSON::ParserError
      logger.error "ERROR: Unable to process as json: #{message}"
      message
    end
  end
end
