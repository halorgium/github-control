require 'irb'

module GithubControl
  module Actions
    class Shell < Action
      register :shell

      def add_options(parser)
      end

      def call
        console = @cli.console
        puts "You are now able to interact with Github via the 'github' method"
        Object.send(:define_method, :github) { console }
        IRB.start
      end
    end
  end
end
