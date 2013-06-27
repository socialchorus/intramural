module Intramural
  module Inline
    class Writer
      include Mixin

      attr_reader :message, :config, :logger

      def initialize(message, options={})
        @message = message
        configure(options)
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
