module Github
  class Repository
    def initialize(owner, name)
      @owner, @name = owner, name
    end
    attr_reader :owner, :name

    def full_name
      "#{@owner.name}/#{@name}"
    end

    def collaborators
      @collaborators ||= Collaborators.new(self)
    end
  end
end
