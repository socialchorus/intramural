module Intramural
  module Standalone
    class App
      attr_reader :logger, :config

      def initialize(options={})
        @logger = options[:logger] || Intramural.logger
        @config = options[:config] || Intramural.config
      end

      def run(&block)
        EventMachine.run do
          queue.subscribe(:ack => true) do |metadata, message|
            if Processor.new(message, logger, &block).perform
              acknowlege(metadata)
            end
          end

          quit_queue.subscribe do |message|
            quit(message)
          end
        end
      end

      def acknowlege(metadata)
        channel.acknowledge(metadata.delivery_tag, false)
      end

      def quit(message='no message given')
        close_connection {
          logger.warn("EXITING Intramural Standalone App: #{message}")
          EventMachine.stop { exit }
        }
      end

      def connection
        @connection ||= Intramural::Standalone::Connection.new(config, logger)
      end

      def channel
        connection.channel
      end

      def queue
        connection.queue
      end

      def quit_queue
        connection.quit_queue
      end

      def close_connection(&block)
        connection.close(&block)
        @connection = nil
      end
    end
  end
end
