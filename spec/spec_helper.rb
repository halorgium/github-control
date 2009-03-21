require 'spec'
require 'randexp'

require File.dirname(__FILE__) + '/../lib/github'

Spec::Runner.configure do |config|
  config.mock_with(:rr)
end
