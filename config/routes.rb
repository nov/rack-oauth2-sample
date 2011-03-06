token_endpoint = Rack::OAuth2::Server::Token.new do |req, res|
  client = Client.find_by_identifier(req.client_id) || req.invalid_client!
  client.secret == req.client_secret || req.invalid_client!
  case req.grant_type
  when :authorization_code
    code = AuthorizationCode.valid.find_by_code(req.code)
    req.invalid_grant! if code.blank? || code.redirect_uri != req.redirect_uri
    res.access_token = code.access_token.token
    res.token_type = :bearer
    res.expires_in = code.access_token.expires_in
  else
    req.unsupported_grant_type!
  end
end

RackOauth2Sample::Application.routes.draw do
  resources :protected_resources, :only => [:index, :show, :create, :destroy]
  resources :clients, :only => [:show, :new, :create]
  resources :authorizations, :only => :create
  match 'oauth2/authorize', :to => 'authorizations#new'
  post 'oauth2/token', :to => proc { |env| token_endpoint.call(env) }

  resource :dashboard, :only => :show
  resource :session, :only => :new
  root :to => 'accounts#new'
end
