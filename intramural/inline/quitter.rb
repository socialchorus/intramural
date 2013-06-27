module Intramural
  module Inline
    class Quitter
      include Mixin

      attr_reader :message

      def initialize(message=nil, options={})
        @message = message || 'no reason given'
        configure(options)
      end

      def queue_name
        quit_queue.name
      end

      def perform
        exchange.publish(message.to_s, routing_key: queue_name)
      end
    end
  end
end
