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
  end
end
