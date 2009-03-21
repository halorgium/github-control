module Github
  module Actions
    class RemoveCollaborators < Action
      def add_options(parser)
        parser.on("-R name", "--repository name", "The repository on Github") do |repository_name|
          options[:repository_name] = repository_name
        end

        parser.on("-U name", "--user name", "The user on Github") do |user_name|
          options[:user_name] = user_name
        end
      end

      def call
        puts "Removing #{user.name} from the collaborators of #{repository.full_name}"
        puts "-" * 40
        unless repository.collaborators.include?(user)
          puts "#{user.name} is not a collaborator"
        else
          repository.collaborators.delete(user)
          puts "Done"
        end
      end

      def repository
        @cli.current_user.repo_for(options[:repository_name] || raise(ProblemWithOptions, "Please specify a repository"))
      end

      def user
        @cli.user_for(options[:user_name] || raise(ProblemWithOptions, "Please specify a user"))
      end
    end
  end
end
