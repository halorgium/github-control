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

    def post(path, params={})
      params.merge!(:login => user_name, :token => user_token)
      data = JSON.parse(Rack::Client.post(url_for(path), params).body)
      if error = data["error"]
        raise APIError, error.inspect
      else
        data
      end
    end

    def url_for(path)
      "http://github.com/api/v2/json#{path}"
    end

    def user_name
      @user_config["name"] ||
        raise(ProblemWithOptions, "You need to provide the user name in the YAML file")
    end

    def user_token
      @user_config["token"] ||
        raise(ProblemWithOptions, "You need to provide the user token in the YAML file")
    end

    def user_password
      @user_config["password"] ||
        raise(ProblemWithOptions, "You need to provide the user password in the YAML file")
    end

    def inspect
      "#<#{self.class} logged in as #{current_user.name.inspect}>"
    end
  end
end
