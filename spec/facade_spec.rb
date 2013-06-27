require 'spec_helper'

describe Intramural do
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

  describe 'inline processes' do
    let(:events) { [] }

    describe '.write' do
      let(:message) { {foo: 'bar'} }

      it "writes to a json message to the default queue" do
        Intramural.write(message)

        Intramural::Inline::Reader.new.run do |m|
          events.push(m)
        end
        events.size.should == 1
        events.first.should == {'foo' => 'bar'}
      end
    end

    describe '.read' do
      let(:message) { {hello: 'world'} }

      before do
        Intramural.write(message)
      end

      it 'reads from the default queue and call the callback' do
        Intramural.read do |m|
          events.push(m)
        end

        events.first['hello'].should == 'world'
      end

      it 'passes along the default logger' do
        Intramural.logger.should_receive(:error).with(message.to_json)

        Intramural.read do |m, logger|
          logger.error(m.to_json)
        end
      end
    end

    describe '.quit!' do
      let(:quitter) { mock }

      it 'performs the quitter' do
        Intramural::Inline::Quitter.should_receive(:new).and_return(quitter)
        quitter.should_receive(:perform)

        Intramural.quit!
      end
    end
  end
end
