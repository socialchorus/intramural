module Intramural
  def self.config=(hash)
    queue_name = hash[:queue_name]
    @config = Intramural::Config.new(queue_name, hash)
  end

  def self.config
    @config
  end

  def self.logger=(logger)
    @logger = logger
  end

  def self.logger
    @logger ||= Intramural::Logger.new
  end

  def self.write(queue_name, message)
    Intramural::Inline::Writer.new(queue_name, message).perform
  end

  def self.read(&block)
    Intramural::Inline::Reader.new.run(&block)
  end

  def self.quit!
    Intramural::Inline::Quitter.new.perform
  end
end
