module GithubControl
  class Action
    def self.register(name)
      Action.set[name.to_s] = self
    end

    def self.set
      @set ||= {}
    end

    def initialize(cli)
      @cli = cli
    end

    def options
      @options ||= {}
    end

    def add_options(parser)
      raise NotImplementedError, "Please implement the #{self.class}#add_options method"
    end

    def call
      raise NotImplementedError, "Please implement the #{self.class}#call method"
    end
  end
end
