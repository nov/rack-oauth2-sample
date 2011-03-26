def setup_response(response, access_token, with_refresh_token = false)
  response.access_token = access_token.token
  response.refresh_token = access_token.create_refresh_token(
    :account => access_token.account,
    :client => access_token.client
  ).token if with_refresh_token
  response.token_type = access_token.token_type
  response.expires_in = access_token.expires_in
end

token_endpoint = Rack::OAuth2::Server::Token.new do |req, res|
  client = Client.find_by_identifier(req.client_id) || req.invalid_client!
  client.secret == req.client_secret || req.invalid_client!
  case req.grant_type
  when :authorization_code
    code = AuthorizationCode.valid.find_by_code(req.code)
    req.invalid_grant! if code.blank? || code.redirect_uri != req.redirect_uri
    setup_response res, code.access_token, :with_refresh_token
  when :password
    # NOTE: password is not hashed in this sample app. Don't do the same on your app.
    account = Account.find_by_username_and_password(req.username, req.password) || req.invalid_grant!
    setup_response res, account.access_tokens.create(:client => client), :with_refresh_token
  when :client_credentials
    # NOTE: client is already authenticated here.
    setup_response res, client.access_tokens.create, :with_refresh_token
  when :refresh_token
    refresh_token = client.refresh_tokens.valid.find_by_token(req.refresh_token)
    req.invalid_grant! unless refresh_token
    setup_response res, refresh_token.access_tokens.create
  else
    # NOTE: extended assertion grant_types are not supported yet.
    req.unsupported_grant_type!
  end
end

RackOauth2Sample::Application.routes.draw do
  resource  :client_statistic, :only => :show
  resources :protected_resources, :only => [:index, :show, :create, :destroy]
  resources :clients, :only => [:show, :new, :create]
  resources :authorizations, :only => :create
  match 'oauth2/authorize', :to => 'authorizations#new'
  post 'oauth2/token', :to => proc { |env| token_endpoint.call(env) }

  resource :dashboard, :only => :show
  resource :session, :only => :new
  resource :account, :only => :update
  root :to => 'accounts#new'
end
