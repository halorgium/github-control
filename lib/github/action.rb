module Github
  class Action
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
