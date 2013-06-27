module Intramural
  module Inline
    class Connection < Intramural::Connection
      def connection
        return @connection if @connection
        @connection = Bunny.new(config.connection_params)
        @connection.start
        @connection
      end

      def channel
        @channel ||= connection.create_channel
      end

      def close
        connection.close
      end
    end
  end
end
