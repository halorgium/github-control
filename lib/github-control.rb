require 'yaml'
require 'json'
require 'rest_client'

module GithubControl
  class Error < StandardError; end
  class APIError < Error; end
  class ProblemWithOptions < Error; end
end

$:.unshift File.dirname(__FILE__)

require 'github-control/version'
require 'github-control/cli'
require 'github-control/console'
require 'github-control/user'
require 'github-control/repository'
require 'github-control/collaborators'

require 'github-control/action'
require 'github-control/actions/repositories'
require 'github-control/actions/shell'
require 'github-control/actions/collaborators'
require 'github-control/actions/add_collaborators'
require 'github-control/actions/remove_collaborators'
