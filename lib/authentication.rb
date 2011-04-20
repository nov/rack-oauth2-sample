module Authentication

  class Unauthorized < StandardError; end

  def self.included(base)
    base.send(:include, Authentication::HelperMethods)
    base.send(:include, Authentication::ControllerMethods)
  end

  module HelperMethods

    def current_account
      @current_account ||= Account.find(session[:current_account])
    rescue ActiveRecord::RecordNotFound
      nil
    end

    def current_token
      @current_token
    end

    def current_client
      @current_client
    end

    def authenticated?
      !current_account.blank?
    end

  end

  module ControllerMethods

    def require_authentication
      authenticate Account.find_by_id(session[:current_account])
    rescue Unauthorized => e
      redirect_to root_url and return false
    end

    def require_oauth_token
      @current_token = AccessToken.find_by_token request.env[Rack::OAuth2::Server::Resource::ACCESS_TOKEN]
      raise Rack::OAuth2::Server::Resource::Bearer::Unauthorized unless @current_token
    end

    def require_oauth_user_token
      require_oauth_token
      raise Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new(:invalid_token, 'User token is required') unless @current_token.account
      authenticate @current_token.account
    end

    def require_oauth_client_token
      require_oauth_token
      raise Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new(:invalid_token, 'Client token is required') if @current_token.account
      @current_client = @current_token.client
    end

    def authenticate(account)
      raise Unauthorized unless account
      session[:current_account] = account.id
    end

    def unauthenticate
      current_account.destroy
      @current_account = session[:current_account] = nil
    end

  end

end