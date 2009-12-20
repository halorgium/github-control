require 'optparse'

module GithubControl
  class CLI
    def self.execute(args)
      new(args).run
    end

    def initialize(args)
      @args = args
    end

    def run
      current_action.add_options(option_parser)
      option_parser.parse!(@args)
      current_action.call
    rescue ProblemWithOptions, OptionParser::ParseError => e
      puts e.backtrace
      $stderr.puts
      $stderr.puts e.message
      $stderr.puts
      $stderr.puts option_parser
      exit 2
    end

    def current_action
      @current_action ||= create_action
    end

    def create_action
      case action_name
      when "list"
        Actions::Repositories.new(self)
      when "shell"
        Actions::Shell.new(self)
      when "collab"
        Actions::Collaborators.new(self)
      when "add_collab"
        Actions::AddCollaborators.new(self)
      when "remove_collab"
        Actions::RemoveCollaborators.new(self)
      else
        raise ProblemWithOptions, "#{action_name} is not a valid action"
      end
    end

    def action_name
      @action_name ||= @args.shift || raise(ProblemWithOptions,
        "Please provide an action to run")
    end

    def console
      @console ||= Console.new(config)
    end

    def environment
      @env ||= options[:environment] || raise(ProblemWithOptions,
        "Please provide an environment to use")
    end

    def config
      @config ||= YAML.load_file(config_file)[environment]
    end

    def config_file
      options[:config] || raise(ProblemWithOptions,
        "You need to provide the path to the YAML filename")
    end

    def options
      @options ||= {
        :debug => false,
        :argv  => @args,
      }
    end

    def option_parser
      @option_parser ||= OptionParser.new do |opts|
        opts.banner = "Usage: github-control #{@action_name || '[action]'} [options] ..."

        opts.on_tail("-h", "--help", "Show this message") do
          $stderr.puts opts
          exit
        end

        opts.on("--debug", "Display debugging information") {
          options[:debug] = true
          $debug = true
        }

        opts.on("-c filename", "--config filename", "Load the config from this YAML file") do |filename|
          options[:config] = filename
        end

        opts.on("-e ENV", "Access this environment") do |env|
          options[:environment] = env
        end

        opts.on("-v", "--version", "Display the github version, and exit.") do
          puts "Github Control version #{GithubControl::VERSION}"
          exit
        end

        opts.separator ""
      end
    end

    def inspect
      "#<#{self.class} logged in as #{current_user.name.inspect}>"
    end
  end
end
