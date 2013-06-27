here = File.dirname(__FILE__)
require "#{here}/../lib/intramural"
Dir["#{here}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
end
