module GithubControl
  class User
    attr_reader :cli, :name

    def initialize(cli, name)
      @cli, @name = cli, name
    end

    def repositories
      @repos ||= Repositories.new(self)
    end

    def public_repositories
      repositories.select { |r| r.public? }
    end

    def private_repositories
      repositories.select { |r| r.private? }
    end
  end
end
