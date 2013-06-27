module Intramural
  module Standalone
    class Connection < Intramural::Connection
      def connection
        @connection ||= AMQP.connect(config.connection_params)
      end

      def channel
        @channel ||= AMQP::Channel.new(connection)
      end

      def close(&block)
        connection.close(&block)
      end
    end
  end
end

