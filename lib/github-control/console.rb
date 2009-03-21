module GithubControl
  class Console
    def initialize(user_config)
      @user_config = user_config
      @users = {}
    end

    def current_user
      @current_user ||= user_for(user_name)
    end

    def user_for(name)
      @users[name] ||= User.new(self, name)
    end

    def api_post(version, path, headers = {})
      data = JSON.parse(http_post("/api/#{version}/json#{path}", headers))
      if error = data["error"]
        raise APIError, error.first["error"]
      else
        data
      end
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
      @user_config["name"] || raise(ProblemWithOptions, "You need to provide the user name in the YAML file")
    end

    def user_token
      @user_config["token"] || raise(ProblemWithOptions, "You need to provide the user token in the YAML file")
    end

    def user_password
      @user_config["password"] || raise(ProblemWithOptions, "You need to provide the user password in the YAML file")
    end

    def inspect
      "#<#{self.class} logged in as #{current_user.name.inspect}>"
    end
  end
end
