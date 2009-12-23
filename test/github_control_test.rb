require "test/unit"
require "github-control"

class GithubControlTest < Test::Unit::TestCase
  def setup
    @config  = YAML.load_file("test/config.yml")["user"]
    @console = GithubControl::Console.new(@config)
    @user    = @console.current_user
  end

  def test_public_repo
    @user.repositories.create("test-public", :public)

    assert @user.repositories["test-public"].public?
    assert_equal "test-public", @user.repositories["test-public"].name
  ensure
    sleep 5
    @user.repositories.delete("test-public")
  end

  def test_private_repo
    @user.repositories.create("test-private", :private)

    assert @user.repositories["test-private"].private?
    assert_equal "test-private", @user.repositories["test-private"].name
  ensure
    sleep 5
    @user.repositories.delete("test-private")
  end

  def test_collaborators
    repo = @user.repositories.create("test-collaborators", :public)
    repo.collaborators.create("atmos")
    repo.collaborators.create("halorgium")

    assert_equal 3, repo.collaborators.size

    repo.collaborators.delete("atmos")

    assert_equal 2, repo.collaborators.size
  ensure
    sleep 5
    @user.repositories.delete("test-collaborators")
  end
end
