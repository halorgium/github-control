require 'yaml'
require 'json'
require 'rest_client'

module Github
  class Error < StandardError; end
  class UsingDefaultCredentials < Error; end
  class FailedLogin < Error; end
  class ProblemWithOptions < Error; end
end

$:.unshift File.dirname(__FILE__)

require 'github/version'
require 'github/cli'
require 'github/user'
require 'github/repository'
require 'github/collaborators'

require 'github/action'
require 'github/actions/repositories'
require 'github/actions/add_collaborators'
require 'github/actions/remove_collaborators'
