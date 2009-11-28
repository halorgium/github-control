require 'spec'
require 'randexp'
require "pp"

require File.dirname(__FILE__) + '/../lib/github-control'

Spec::Runner.configure do |config|
  config.mock_with(:rr)
  config.before(:all) do
    @console = GithubControl::Console.new(YAML.load_file(File.dirname(__FILE__) + '/config.yml')["user"])
  end
end
