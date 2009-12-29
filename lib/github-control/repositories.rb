module GithubControl
  class Repositories
    include Enumerable

    def initialize(user)
      @user  = user
    end

    def create(name, access)
      @user.cli.post("/repos/create",
        :name    => name,
        :public  => access == :public ? 1 : 0
      )

      repo = Repository.new(@user, name, access)
      set << repo
      repo
    end

    def [](name)
      get(name)
    end

    def get(name)
      set.detect { |r| r.name == name }
    end

    def delete(name)
      response = @user.cli.post("/repos/delete/#{name}")
      @user.cli.post("/repos/delete/#{name}",
        :delete_token => response["delete_token"])
      any? && set.delete(name)
    end

    def destroy
      each { |r| delete(r.name) }
    end

    def each(&block)
      set.each(&block)
    end

    def clear
      @set = nil
    end

    def empty?
      ! any?
    end

    def size
      set.size
    end

    private
      def set
        @set ||= @user.cli.post("/repos/show/#{@user.name}")["repositories"].
          sort_by { |r| r["name"] }.
          map { |r|
            access = r["private"] ? :private : :public
            Repository.new(@user, r["name"], access)
          }
      end
  end
end
