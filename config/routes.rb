RackOauth2Sample::Application.routes.draw do
  resources :client, :only => [:new, :create]
  resources :authorizations, :only => :create
  resources :tokens, :only => :create
  match 'oauth2/authorize', :to => 'authorizations#new'
  match 'oauth2/token', :to => 'tokens#new'

  resource :dashboard, :only => :show
  resource :session, :only => :new
  root :to => 'accounts#new'
end
