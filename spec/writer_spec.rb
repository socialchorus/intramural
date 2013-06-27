require 'spec_helper'

describe Intramural::Inline::Writer do
  before :all do
    Intramural.config = {
      queue_name: 'intramural_test'
    }
    Intramural.logger = Logger.new('/dev/null')
  end

  after do
    queue = Intramural::Inline::Connection.new(Intramural.config, Intramural.logger).queue
    queue.purge
  end

  let(:message) { {foo: 'bar'} }
  let(:events) { [] }

  let(:writer) {
    Intramural::Inline::Writer.new(message)
  }

  describe '#run' do
    it "writes the message to the queue as json" do
      writer.perform

      connection = Intramural::Inline::Connection.new(Intramural.config, Intramural.logger)
      connection.queue.subscribe do |delivery_info, metadata, message|
        events.push(message)
      end
      sleep 0.001
      connection.close

      events.size.should == 1
      events.first.should == message.to_json
    end
  end
end

