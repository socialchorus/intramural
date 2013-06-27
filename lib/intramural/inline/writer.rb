module Intramural
  module Inline
    class Writer
      include Mixin

      attr_reader :message, :config, :logger

      def initialize(queue_name, message, options={})
        @message = message
        configure(options)
        @config.queue = queue_name
      end

      def queue_name
        queue.name
      end

      def perform
        exchange.publish(message.to_json, routing_key: queue_name)
      end
    end
  end
end
