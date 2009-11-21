require "spec_helper"

describe "Github Control" do
  def config
    config  = YAML.load_file("config.yml")["test"]
  end

  def console
    console = GithubControl::Console.new(config)
  end

  def current_user
    console.current_user
  end

  before(:each) do
    current_user.repositories.each { |r| r.destroy }
  end

  it "creates a repository" do
    lambda {
      current_user.add_repository("test-repo", :public)
    }.should change(repo.repositories.cout).by(1)

    current_user.repo_for("test-repo").should be_public
  end

  it "creates private and public repositories" do
    5.times { |i|
      current_user.add_repository("test-repo-#{i}", i.even? ? :public : :private
    }

    current_user.should have(5).repositories
    current_user.should have(2).private_repositories
    current_user.should have(2).public_repositories
  end

  it "creates and destroys collaborators on a repository" do
    repo = current_user.add_repository("test-repo", :public)
    repo.collaborators << GitHubControl::User.new("atmos")
    repo.collaborators << GitHubControl::User.new("tim")
    repo.collaborators << GitHubControl::User.new("ben")
    repo.collaborators << GitHubControl::User.new("sr")

    repo.should have(4).collaborators

    # sorry dude :(
    repo.collaborators.delete("atmos")
  end

  it "adds and remove post-receive urls"
end
