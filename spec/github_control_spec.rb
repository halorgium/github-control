require "spec_helper"

describe "Github Control" do
  def config
    @config ||= YAML.load_file("spec/config.yml")["user"]
  end

  def console
    @console ||= GithubControl::Console.new(config)
  end

  def current_user
    @user ||= console.current_user
  end

  before(:all) do
    RestClient.log = "restclient.log"
  end

  before(:each) do
    current_user.repositories.destroy
  end

  it "creates a public repository" do
    current_user.should have(:no).repositories
    current_user.repositories.create("public-repo", :public)
    current_user.should have(1).repositories
    current_user.repositories["public-repo"].should be_public
  end

  it "creates a private repository" do
    current_user.should have(:no).private_repositories
    current_user.repositories.create("private-repo", :private)
    current_user.should have(1).private_repositories
    current_user.repositories["private-repo"].should be_private
  end

  it "creates and destroys collaborators on a repository" do
    repo = current_user.repositories.create("test-repo", :public)
    repo.collaborators << GithubControl::User.new("atmos", console)
    repo.collaborators << GithubControl::User.new("tim", console)
    repo.collaborators << GithubControl::User.new("ben", console)
    repo.collaborators << GithubControl::User.new("sr", console)

    repo.should have(4).collaborators

    # sorry dude :(
    repo.collaborators.delete("atmos")
    repo.should have(3).collaborators
  end

  it "adds and remove post-receive urls"
end
