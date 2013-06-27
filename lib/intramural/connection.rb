module Intramural
  class Connection
    attr_reader :config, :logger

    def initialize(config, logger)
      @logger = logger
      @config = config
    end

    def queue
      channel.queue(config.queue, {
        :auto_delete => false,
        :durable => true,
        :exclusive => false
      })
    end

    def queue_size
      queue.message_count
    end

    def quit_queue
      channel.queue("#{config.queue}.quit", {
        :auto_delete => true,
        :durable => false,
        :exclusive => false
      })
    end

    def connection
      raise 'implement me'
    end

    def channel
      raise 'implement me'
    end

    def close
      connection.close
    end
  end
end

