# Intramural

Intramural establishes some conventions and wraps some great gems to
make intra-app communication in the age of service-oriented-architecture
easy!


## Installation

Add this line to your application's Gemfile:

    gem 'intramural'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install intramural

## Usage

Intramural is designed with the notion that every application will have
a single queue name, its address in RabbitMQ land. You can work with
individual classes to break this convention, but the easiest way forward
is to just do it. Intramural uses both `bunny`, a synchronous amqp gem,
and `amqp`, an asynchronous gem to provide lots of flexible options for
writing and reading from queues. In addition to in process read and
write operations, there is an EventMachine application, replete with a
harm reducing quit command.

#### Configure each application

Queue name on a per app basis is the only required configuration:

    Intramural.config = {
      queue_name: 'my_app_identifier'
    }   

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
