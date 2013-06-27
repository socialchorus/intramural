module Intramural
  class Config
    attr_reader :additional_config, :queue

    def initialize(queue_name, additional_config={})
      @queue = queue_name
      @additional_config = additional_config
    end

    def connection_params
      env_params || default
    end

    def env_connection_key
      additional_config[:connection_key] || 'RABBITMQ_URL'
    end

    def env_params
      ENV[env_connection_key]
    end

    def default
      additional_config[:connection_params] || {host: '127.0.0.1'}
    end

    def quit_queue
      "#{queue}.quit"
    end
  end
end
