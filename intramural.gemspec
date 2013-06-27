# coding: utf-8
lib = File.expand_path('../intramural', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "intramural"
  spec.version       = Intramural::VERSION
  spec.authors       = ["Kane Baccigalupi", "SocialChorus"]
  spec.email         = ["developers@socialchorus.com"]
  spec.description   = %q{Intramural uses both `bunny`, a synchronous amqp gem,
and `amqp`, an asynchronous gem, to provide lots of flexible options for
writing and reading to queues. In addition to in process read and
write operations, there is an EventMachine application, replete with a
harm reducing quit command.}
  spec.summary       = %q{Intramural establishes some conventions and wraps some great gems to make intra-app communication in the age of service-oriented-architecture easy!}
  spec.homepage      = "http://github.com/socialchorus/intramural"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["intramural"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
