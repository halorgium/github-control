module GithubControl
  module Actions
    class Repositories < Action
      def add_options(parser)
        parser.on("-U name", "--user name", "The user to list the repositories") do |user_name|
          options[:user_name] = user_name
        end
      end

      def call
        puts "Repositories for #{user.name}"
        puts "-" * 40
        user.repositories.each do |repo|
          puts "- #{repo.name}"
        end
      end

      def user
        @cli.user_for(options[:user_name] || @cli.user_name)
      end
    end
  end
end
