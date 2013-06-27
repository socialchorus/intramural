module Intramural
  module Inline
    module Mixin
      def self.included(base)
        base.class_eval do
          attr_reader :logger, :config
        end
      end

      def configure(options)
        @logger = options[:logger] || Intramural.logger
        @config = options[:config] || Intramural.config
      end

      def connection
        @connection ||= Inline::Connection.new(config, logger)
      end

      def queue
        connection.queue
      end

      def quit_queue
        connection.quit_queue
      end

      def channel
        connection.channel
      end

      def exchange
        channel.default_exchange
      end

      def close
        connection.close
        @connection = nil
      end
    end
  end
end
