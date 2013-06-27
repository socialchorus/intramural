module Intramural
  module Inline
    class Reader
      include Mixin

      def initialize(options={})
        configure(options)
      end

      def run(&block)
        queue.subscribe(:ack => true) do |delivery_info, metadata, message|
          process(delivery_info, message, block)
        end
        sleep 0.001 # there are intermitten failures if this is not here :(
        # will file a bug with Bunny when this is open sourced
        close
      end

      def process(delivery_info, message, block)
        if Processor.new(message, logger, &block).perform
          acknowlege(delivery_info)
        end
      end

      def acknowlege(delivery_info)
        channel.acknowledge(delivery_info.delivery_tag, false)
      end
    end
  end
end
