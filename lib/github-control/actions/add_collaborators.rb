module GithubControl
  module Actions
    class AddCollaborators < Action
      register :add_collab

      def add_options(parser)
        parser.on("-R name", "--repository name", "The repository on Github") do |repository_name|
          options[:repository_name] = repository_name
        end

        parser.on("-U name", "--user name", "The user on Github") do |user_name|
          options[:user_name] = user_name
        end
      end

      def call
        puts "Adding #{user.name} to the collaborators of #{repository.full_name}"
        puts "-" * 40
        if repository.collaborators.include?(user)
          puts "#{user.name} is already a collaborator"
        else
          repository.collaborators << user
          puts "Done"
        end
      end

      def repository
        @cli.console.current_user.repo_for(options[:repository_name] || raise(ProblemWithOptions, "Please specify a repository"))
      end

      def user
        @cli.console.user_for(options[:user_name] || raise(ProblemWithOptions, "Please specify a user"))
      end
    end
  end
end
