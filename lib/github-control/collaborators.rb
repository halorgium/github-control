module GithubControl
  class Collaborators
    include Enumerable

    def initialize(repository)
      @repository = repository
    end
    attr_reader :repository

    def <<(user)
      @repository.owner.cli.scrape_post("/#{@repository.owner.name}/#{@repository.name}/edit/add_member",
                                        {:member => user.name}, :accept => 'text/javascript')
      # TODO: @repository.owner.cli.http_post("/api/v2/json/repos/collaborators/#{@repository.owner.name}/add/#{user.name}")
    end

    def delete(user)
      @repository.owner.cli.scrape_get("/#{@repository.owner.name}/#{@repository.name}/edit/remove_member?member=#{user.name}",
                                       :accept => 'text/javascript')
      # TODO: @repository.owner.cli.http_post("/api/v2/json/repos/collaborators/#{@repository.owner.name}/remove/#{user.name}")
    end

    def each(&block)
      set.each(&block)
    end

    def set
      json_data["collaborators"].map do |name|
        @repository.owner.cli.user_for(name)
      end
    end

    def json_data
      JSON.parse(@repository.owner.cli.http_get("/api/v2/json/repos/show/#{@repository.owner.name}/#{@repository.name}/collaborators"))
    end
  end
end
