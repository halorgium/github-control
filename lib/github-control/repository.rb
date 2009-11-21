module GithubControl
  class Repository
    def initialize(owner, name, access)
      @owner, @name, @access = owner, name, access
    end
    attr_reader :owner, :name, :access

    def private?
      @access == :private
    end

    def public?
      @access == :public
    end

    def full_name
      "#{@owner.name}/#{@name}"
    end

    def collaborators
      @collaborators ||= Collaborators.new(self)
    end

    def post_receive_urls
      @post_receive_urls ||= PostReceiveUrls.new(self)
    end

    def destroy
      response = @owner.cli.api_post("v2", "/repos/delete/#{@name}")
      @owner.cli.http_post("/api/v2/json/repos/delete/#{@name}",
        :delete_token => response["delete_token"])
    end
  end
end
