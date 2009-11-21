module GithubControl
  class Repository
    attr_reader :owner, :name, :access

    def initialize(owner, name, access)
      @owner, @name, @access = owner, name, access
    end

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
      @owner.repositories.delete(@name)
    end
  end
end
