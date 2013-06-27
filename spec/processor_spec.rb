require 'spec_helper'

describe Intramural::Processor do
  let(:message) {
    {foo: 'bar'}.to_json
  }
  let(:logger) { Logger.new('/dev/null') }
  let(:event_arguments) { [] }
  let(:register_event) { lambda { |args| event_arguments.push(args) } }

  let(:processor) {
    Intramural::Processor.new(message, logger) do |arguments|
      register_event.call(arguments)
    end
  }

  describe '#perform' do
    context 'success' do
      it "logs around the event" do
        logger.should_receive(:info).exactly(2).times
        processor.perform
      end

      it "calls the block with a json representation of the message" do
        processor.perform
        event_arguments.first.should == {'foo' => 'bar'}
      end

      it "returns true" do
        processor.perform
      end
    end

    context 'exception in the call block' do
      let(:register_event) {
        lambda { |args| raise ArgumentError }
      }

      it "logs an error" do
        logger.should_receive(:error)
        processor.perform
      end

      it "returns false" do
        processor.perform.should == false
      end
    end
  end
end
