require 'irb'

module GithubControl
  module Actions
    class Shell < Action
      class Console
        def initialize(cli)
          @cli = cli
        end

        def user_for(name)
          @cli.user_for(name)
        end

        def inspect
          "#<GithubControl::Console logged in as #{@cli.current_user.name.inspect}>"
        end
      end

      def add_options(parser)
      end

      def call
        console = Console.new(@cli)
        puts "You are now able to interact with Github via the 'github' method"
        Object.send(:define_method, :github) { console }
        IRB.start
      end
    end
  end
end
