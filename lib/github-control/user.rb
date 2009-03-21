module GithubControl
  class User
    def initialize(cli, name)
      @cli, @name = cli, name
      @repos = {}
    end
    attr_reader :cli, :name

    def public_repositories
      repositories.select do |r|
        r.public?
      end
    end

    def private_repositories
      repositories.select do |r|
        r.private?
      end
    end

    def repositories
      json_data["user"]["repositories"].sort_by {|r| r["name"]}.map do |data|
        @cli.user_for(data["owner"]).repo_for(data["name"], data["private"] ? :private : :public)
        # "watchers"=>1,
        # "private"=>false,
        # "fork"=>false,
        # "url"=>"http://github.com/authorizer/test-1",
        # "homepage"=>"",
        # "forks"=>0,
        # "description"=>"",
      end
    end

    def json_data
      JSON.parse(@cli.http_post("/api/v1/json/#{@name}"))
    end

    def repo_for(name, access)
      @repos[name] ||= Repository.new(self, name, access)
    end
  end
end
