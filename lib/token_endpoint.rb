class TokenEndpoint

  def call(env)
    authenticator.call(env)
  end

  private

  def authenticator
    Rack::OAuth2::Server::Token.new do |req, res|
      client = Client.find_by_identifier(req.client_id) || req.invalid_client!
      client.secret == req.client_secret || req.invalid_client!
      case req.grant_type
      when :authorization_code
        code = AuthorizationCode.valid.find_by_token(req.code)
        req.invalid_grant! if code.blank? || code.redirect_uri != req.redirect_uri
        setup_response res, code.access_token, :with_refresh_token
      when :password
        # NOTE: password is not hashed in this sample app. Don't do the same on your app.
        account = Account.find_by_username_and_password(req.username, req.password) || req.invalid_grant!
        setup_response res, account.access_tokens.create(:client => client), :with_refresh_token
      when :client_credentials
        # NOTE: client is already authenticated here.
        setup_response res, client.access_tokens.create
      when :refresh_token
        refresh_token = client.refresh_tokens.valid.find_by_token(req.refresh_token)
        req.invalid_grant! unless refresh_token
        setup_response res, refresh_token.access_tokens.create
      else
        # NOTE: extended assertion grant_types are not supported yet.
        req.unsupported_grant_type!
      end
    end
  end

  def setup_response(response, access_token, with_refresh_token = false)
    bearer_token = Rack::OAuth2::AccessToken::Bearer.new(
      :access_token => access_token.token,
      :expires_in => access_token.expires_in
    )
    if with_refresh_token
      bearer_token.refresh_token = access_token.create_refresh_token(
        :account => access_token.account,
        :client => access_token.client
      ).token
    end
    response.access_token = bearer_token
  end

end