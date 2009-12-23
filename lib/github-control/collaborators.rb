module GithubControl
  class Collaborators
    include Enumerable

    attr_reader :repository

    def initialize(repository)
      @repository = repository
    end

    def create(user)
      @repository.owner.cli.post("/repos/collaborators/" \
        "#{@repository.name}/add/#{user}")
      set << @repository.owner.cli.user_for(user)
    end

    def delete(user)
      @repository.owner.cli.post("/repos/collaborators/" \
        "#{@repository.name}/remove/#{user}")
      set.delete_if { |u| u.name == user }
    end

    def each(&block)
      set.each(&block)
    end

    def size
      set.size
    end

    def set
      @set ||= json_data["collaborators"].map { |name|
        @repository.owner.cli.user_for(name)
      }
    end

    def json_data
      @repository.owner.cli.post("/repos/show/" \
        "#{@repository.owner.name}/#{@repository.name}/collaborators")
    end
  end
end
