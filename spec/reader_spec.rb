require 'spec_helper'

describe Intramural::Inline::Reader do
  before do
    connection = Intramural::Inline::Connection.new(config, logger)
    queue = connection.queue
    exchange = connection.channel.default_exchange
    exchange.publish(message, routing_key: queue.name)
    connection.close
  end

  after do
    queue = Intramural::Inline::Connection.new(config, logger).queue
    queue.purge
  end

  let(:queue_name) { "reader_test" }
  let(:message) { {foo: 'bar'}.to_json }
  let(:logger) { Logger.new('/dev/null') }
  let(:events) { [] }
  let(:config) {
    Intramural::Config.new(queue_name)
  }
  let(:options) {
    {
      logger: logger,
      config: config
    }
  }

  let(:reader) {
    Intramural::Inline::Reader.new(options)
  }

  describe '#run' do
    context 'success' do
      it "logs around the event" do
        logger.should_receive(:info).exactly(2).times
        reader.run do |args|
          events.push(args)
        end
      end

      it "calls the block with a json representation of the message" do
        reader.run do |args|
          events.push(args)
        end
        events.first.should == {'foo' => 'bar'}
      end

      it "acknowleges the message" do
        reader.run do |args|
          events.push(args)
        end

        # queue should be empty of messages,
        # so there is only one event in the array
        reader.run do |args|
          events.push(args)
        end

        events.size.should == 1
      end
    end

    context 'exception in the call block' do
      it "logs an error" do
        logger.should_receive(:error)
        reader.run do |args|
          raise ArgumentError
        end
      end

      it "fails gracefully" do
        expect {
          reader.run do |args|
            raise ArgumentError
          end
        }.not_to raise_error
      end

      it "does not consume the message" do
        reader.run do |args|
          raise ArgumentError
        end

        events.size.should == 0

        reader.run do |args|
          events.push(args)
        end

        sleep 0.1

        events.size.should == 1
      end
    end
  end
end
