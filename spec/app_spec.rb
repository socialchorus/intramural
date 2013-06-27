require 'spec_helper'

describe Intramural::Standalone::App do
  before :all do
    Intramural.config = {
      queue_name: 'intramural_test'
    }
    Intramural.logger = Logger.new('/dev/null')
  end

  let(:events) { [] }
  let(:writer) { Intramural::Inline::Writer.new('intramural_test', {foo: 'bar'}) }
  let(:quitter) { Intramural::Inline::Quitter.new }
  let(:connection) { 
    Intramural::Inline::Connection.new(Intramural.config, Intramural.logger) 
  }

  context "when a message is sent to the quit queue" do
    it "stops the loop process" do
      writer.perform # to get a message into the queue, so the proc gets run

      Intramural::Standalone::App.new.run do |arguments|
        quitter.perform
      end

      true.should == true # not in the infinite event loop!
    end
  end

  context 'event loop' do
    before do
      writer.perform
    end

    it "processes messages when starting" do
      Intramural::Standalone::App.new.run do |arguments|
        events.push(arguments)
        quitter.perform
      end

      events.size.should == 1
      events.first.should == {'foo' => 'bar'}
    end

    it "acknowleges messages after completion" do
      connection.queue_size.should == 1

      Intramural::Standalone::App.new.run do |arguments|
        quitter.perform
      end

      connection.queue_size.should == 0
    end
  end
end
