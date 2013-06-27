module Intramural
  class Processor
    attr_reader :message, :logger, :block
    attr_accessor  :start_time

    def initialize(message, logger, &block)
      @message = message
      @logger = logger
      @block = block
    end

    def perform
      start!
      block.call(arguments, logger)
      finish!
      true
    rescue Exception => e
      logger.error("#{e.message}\n#{e.backtrace}")
      false
    end

    def arguments
      Intramural::Decoder.new(message, logger).perform
    end

    def start!
      self.start_time = Time.now
      logger.info "[#{start_time}] Processing message: #{message}"
    end

    def finish!
      end_time = Time.now
      logger.info "[#{end_time}] Finished message: #{message}\n  in #{start_time - end_time} seconds"
    end
  end
end
