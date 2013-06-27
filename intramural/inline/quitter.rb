module Intramural
  module Inline
    class Quitter < Writer
      # allows no message
      def initialize(message=nil, options={})
        super
      end

      def queue_name
        quit_queue.name
      end

      def perform
        exchange.publish(message.to_json, routing_key: queue_name)
      end
    end
  end
end
