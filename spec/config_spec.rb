require 'spec_helper'

describe Intramural::Config do
  let(:config) {
    Intramural::Config.new(queue_name, additional_config)
  }

  let(:queue_name) {
    'transducer'
  }

  let(:additional_config) {
    {}
  }

  describe '#connection' do
    context "heroku cloudamqp" do
      context 'default behavior' do
        let(:url) { 'http://cloudamqp-url.com' }

        before do
          ENV['RABBITMQ_URL'] = url
        end

        after do
          ENV['RABBITMQ_URL'] = nil
        end

        it "returns the RABBITMQ_URL" do
          config.connection_params.should == url
        end
      end

      context 'additional configuration passed in' do
        let(:url) { 'http://someother-url.com' }
        let(:additional_config) {
          {connection_key: 'SOMEOTHERURL'}
        }

        before do
          ENV['SOMEOTHERURL'] = url
        end

        after do
          ENV['SOMEOTHERURL'] = nil
        end

        it "returns the url specified in the env" do
          config.connection_params.should == url
        end
      end
    end

    context 'local development' do
      context 'default' do
        it "uses the default url" do
          config.connection_params.should == {
            :host => '127.0.0.1'
          }
        end
      end

      context 'connection params passed in' do
        let(:additional_config) {
          {
            connection_params: {
              :host => 'hoo.com'
            }
          }
        }

        it "uses what it is given" do
          config.connection_params.should == additional_config[:connection_params]
        end
      end
    end
  end

  describe 'queues' do
    describe '#quit_queue' do
      it "returns a string related to the original queue name" do
        config.quit_queue.should == "#{queue_name}.quit"
      end
    end
  end
end
