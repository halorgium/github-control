module GithubControl
  module Actions
    class Collaborators < Action
      register :collab

      def add_options(parser)
        parser.on("-R name", "--repository name", "The repository on Github") do |repository_name|
          options[:repository_name] = repository_name
        end

        parser.on("-U name", "--user name", "The user on Github") do |user_name|
          options[:user_name] = user_name
        end
      end

      def call
        puts "Listing the collaborators of #{repository.full_name}"
        puts "-" * 40
        repository.collaborators.each do |user|
          puts "- #{user.name}"
        end
      end

      def repository
        user.repo_for(options[:repository_name] || raise(ProblemWithOptions, "Please specify a repository"))
      end

      def user
        @cli.console.user_for(options[:user_name] || raise(ProblemWithOptions, "Please specify a user"))
      end
    end
  end
end
