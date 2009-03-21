require 'optparse'

module GithubControl
  class CLI
    def self.execute(args)
      new(args).run
    end

    def initialize(args)
      @args = args
      @users = {}
    end

    def run
      current_action.add_options(option_parser)
      option_parser.parse!(@args)
      current_action.call
    rescue ProblemWithOptions, OptionParser::ParseError => e
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
      @action_name ||= @args.shift || raise(ProblemWithOptions, "Please provide an action to run")
    end

    def current_user
      @current_user ||= user_for(user_name)
    end

    def user_for(name)
      @users[name] ||= User.new(self, name)
    end

    def http_get(path, headers = {})
      RestClient.get(url_for(path), headers)
    end

    def http_post(path, params = {}, headers = {})
      params = {:login => user_name, :token => user_token}.merge(params)
      raw_post(path, params, headers)
    end

    def scrape_get(path, headers = {})
      headers = {:cookie => cookies}.merge(headers)
      http_get(path, headers)
    end

    def scrape_post(path, params = {}, headers = {})
      headers = {:cookie => cookies}.merge(headers)
      raw_post(path, params, headers)
    end

    def raw_post(path, params = {}, headers = {}, extra_options = {})
      # TODO: RestClient.post(url_for(path), params, headers)
      options = {:method => :post, :url => url_for(path), :payload => params, :headers => headers}.merge(extra_options)
      RestClient::Request.execute(options)
    end

    def url_for(path)
      "https://github.com#{path}"
    end

    def cookies
      @cookies ||= session_cookie
    end

    def session_cookie
      response = raw_post("/session", {:login => user_name, :password => user_password}, {}, :auto_redirect => false)
      response.headers[:set_cookie].split(";").first
    end

    def user_name
      user_config["name"] || raise(ProblemWithOptions, "You need to provide the user name in the YAML file")
    end

    def user_token
      user_config["token"] || raise(ProblemWithOptions, "You need to provide the user token in the YAML file")
    end

    def user_password
      user_config["password"] || raise(ProblemWithOptions, "You need to provide the user password in the YAML file")
    end

    def user_config
      config["user"] || raise(ProblemWithOptions, "You need to provide user data in the YAML file")
    end

    def config
      @config ||= YAML.load_file(config_filename)
    end

    def config_filename
      options[:config_filename] || raise(ProblemWithOptions, "You need to provide the path to the YAML filename")
    end

    def options
      @options ||= {
        :debug => false,
        :argv => @args,
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
          options[:config_filename] = filename
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
